// File: fnc_dhcp_onTurnOn.sqf
/**
 * Updates ip adress on turn on.
 *
 * Arguments:
 * 0: Device <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity"];

if (isNull _entity) exitWith {};

// Leases are handed out by the server, which is the only machine holding the full device registry.
if (!isServer) exitWith
{
	["ae3_network_dhcpTurnOn", [netId _entity]] call CBA_fnc_serverEvent;
};

private _parent = _entity getVariable ["AE3_network_parent", objNull];
private _leases = _entity getVariable ["AE3_network_staticIpByRouter", createHashMap];
private _staticStr = if (isNull _parent) then { "" } else { _leases getOrDefault [netId _parent, ""] };
private _static = [_staticStr] call AE3_network_fnc_str2ip;

if (_static isNotEqualTo [] && {!([_entity, _static] call AE3_network_fnc_ipInUse)}) then
{
	_entity setVariable ["AE3_network_staticIp", _staticStr, true];
	_entity setVariable ["AE3_network_address", _static, true];
}
else
{
	if (!isNull _parent) then
	{
		// Assign the DHCP lease once the parent router is actually powered. Turn-on ordering can race
		// (router still booting when the client comes up), which previously left the client on the
		// 127.0.0.1 loopback fallback shown in System Settings.
		[
			{ params ["_entity", "_parent"]; !alive _parent || {(_parent getVariable ["AE3_power_powerState", 0]) == 1} },
			{
				params ["_entity", "_parent"];
				_entity setVariable ["AE3_network_staticIp", "", true];
				_entity setVariable ["AE3_network_address", [_parent] call AE3_network_fnc_dhcp_get, true];
			},
			[_entity, _parent]
		] call CBA_fnc_waitUntilAndExecute;
	};
};

if (!isNil {_entity getVariable "AE3_network_children"}) then
{
	/*
	 Sketchy workaround, because this is executed before the
	 power is turned on, which is requiered for the dhcp get request
	 to work.

	 TODO: Improve
	*/
	[{ _this call AE3_network_fnc_dhcp_refresh; }, [_entity], 1] call CBA_fnc_waitAndExecute;
};
