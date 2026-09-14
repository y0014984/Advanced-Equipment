// File: fnc_resolve.sqf
/**
 * Author: Root
 * Resolves a target IP to a device anywhere in the mission and enforces the per-router external
 * access policy. A target on the source's own gateway is always reachable. A target on a different
 * gateway is reachable only when its owning router has external access enabled, and (when that
 * router defines an allow list) only when the source matches one of its entries. Allow-list entries
 * may be a router gateway IP (authorises every laptop on that router's subnet), a specific host IP
 * (authorises just that one laptop) or a regex (matched against the source IP / gateway prefix).
 * The owning router is found from the global router registry by subnet, so two gateways do not need
 * a physical link to reach each other. Returns the matched device and the route length within the
 * target subnet, or objNull when unreachable or blocked.
 *
 * When AE3 (or network) debug mode is enabled the verdict is written to the RPT as [AE3][ROUTE].
 *
 * Arguments:
 * 0: Source device <OBJECT>
 * 1: Target IP <[INT]>
 *
 * Returns:
 * 0: Target <OBJECT>
 * 1: Length <FLOAT>
 */

params ["_source", "_target"];

private _dbg = AE3_DebugMode || {missionNamespace getVariable ["AE3_NetworkDebugEnabled", false]};
private _trace = {
	params ["_reason", ["_dev", objNull]];
	diag_log text format ["[AE3][ROUTE] resolve source=%1 target=%2 :: %3",
		[(_source getVariable ["AE3_network_address", [0, 0, 0, 0]])] call AE3_network_fnc_ip2str,
		[_target] call AE3_network_fnc_ip2str, _reason];
};

// Loopback or the source's own address always resolves to the source itself.
private _srcAddr = _source getVariable ["AE3_network_address", [127, 0, 0, 1]];
if (_target isEqualTo [127, 0, 0, 1] || _target isEqualTo _srcAddr) exitWith
{
	if (_dbg) then {["self"] call _trace};
	[_source, 0];
};

private _srcSub = [_srcAddr select 0, _srcAddr select 1, _srcAddr select 2];
private _tgtSub = [_target select 0, _target select 1, _target select 2];

// Find the router that owns the target subnet. A router that has been switched off carries no traffic,
// so it owns nothing: a subnet whose router is down is unreachable rather than silently still routed.
// Routers that take no part in the power system have no power state to read and are always up.
private _routers = missionNamespace getVariable ["AE3_network_routers", []];
private _tgtRouter = objNull;
{
	if (isNull _x || {!alive _x}) then {continue};
	if ((_x getVariable ["AE3_power_powerState", 1]) != 1) then {continue};
	private _ra = _x getVariable ["AE3_network_address", []];
	if (count _ra == 4 && {[_ra select 0, _ra select 1, _ra select 2] isEqualTo _tgtSub}) exitWith {_tgtRouter = _x};
} forEach _routers;

if (isNull _tgtRouter) exitWith
{
	if (_dbg) then {["no-owning-router"] call _trace};
	[objNull, 0];
};

// Cross-gateway access is gated by the owning router's policy.
if (_srcSub isNotEqualTo _tgtSub) then
{
	if !(_tgtRouter getVariable ["AE3_network_allowExternalSsh", false]) exitWith
	{
		if (_dbg) then {["blocked-external"] call _trace};
		_tgtRouter = objNull;
	};

	private _allow = _tgtRouter getVariable ["AE3_network_externalAllow", ""];
	if (_allow isNotEqualTo "") then
	{
		private _srcStr = [_srcAddr] call AE3_network_fnc_ip2str;
		private _srcGwStr = format ["%1.%2.%3.", _srcSub select 0, _srcSub select 1, _srcSub select 2];
		private _ok = false;
		{
			private _entry = trim _x;
			if (_entry isNotEqualTo "") then
			{
				if (_entry regexMatch "\d{1,3}(\.\d{1,3}){3}") then
				{
					// Plain IPv4 entry. If it is a router gateway, authorise every laptop on that
					// router's subnet; otherwise treat it as a single allowed host.
					private _ip = (_entry splitString ".") apply {parseNumber _x};
					private _isGateway = false;
					{
						if (isNull _x || {!alive _x}) then {continue};
						if ((_x getVariable ["AE3_network_address", []]) isEqualTo _ip) exitWith {_isGateway = true};
					} forEach _routers;
					if (_isGateway) then
					{
						if (_srcSub isEqualTo [_ip select 0, _ip select 1, _ip select 2]) then {_ok = true};
					}
					else
					{
						if (_srcStr isEqualTo _entry) then {_ok = true};
					};
				}
				else
				{
					// Anything else is a regex, matched against the source IP or its gateway prefix.
					try { if (_srcStr regexMatch _entry || {_srcGwStr regexMatch _entry}) then {_ok = true}; } catch {};
				};
			};
		} forEach (_allow splitString ", ");

		if (!_ok) exitWith
		{
			if (_dbg) then {["blocked-not-in-allowlist"] call _trace};
			_tgtRouter = objNull;
		};
	};
};

if (isNull _tgtRouter) exitWith { [objNull, 0] };

// Resolve the actual device inside the target subnet by walking from its owning router.
private _res = [_tgtRouter, _target] call AE3_network_fnc_ping;
if (_dbg) then {[["resolved", "dead-end-in-subnet"] select (isNull (_res select 0))] call _trace};
_res;
