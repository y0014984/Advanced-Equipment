// File: fnc_attr_router.sqf
/**
 * Author: Root
 * Eden object-attribute helper for routers. Applies one wireless setting (network name, gateway,
 * range or password) once the router has finished initialising, so the values entered in the 3DEN
 * attribute editor take effect at mission start regardless of init ordering. A blank gateway/name
 * leaves the auto-assigned value untouched. The "starton" key is handled separately: it waits only
 * for the router's power initialisation, mirroring the laptop start-on behaviour. Server-side.
 *
 * Arguments:
 * 0: Router <OBJECT>
 * 1: Key <STRING> - "ssid" | "gateway" | "range" | "rangemult" | "acceptconn" | "password" | "extssh" | "extallow" | "starton"
 * 2: Value <STRING|NUMBER|BOOL> - Setting value from the attribute
 *
 * Returns:
 * None
 */

params ["_router", ["_key", ""], ["_value", ""]];

// Read the debug flag safely: this runs from an Eden attribute expression which can fire before the
// CBA setting is initialised, so the global may still be nil (a bare reference would throw and abort
// the whole expression, silently skipping the power-on).
private _dbg = missionNamespace getVariable ["AE3_DebugMode", false];
if (_dbg) then { diag_log format ["[AE3 DEBUG] [%1] attr_router CALLED: key=%2 value=%3 (%4) isServer=%5", time, _key, _value, typeName _value, isServer]; };

if (!isServer) exitWith {};

// Power-on is independent of the wireless configuration: it only needs the device's power init to
// finish, not the router-config init, so it is handled outside the AE3_cap_isRouter wait below.
if (_key isEqualTo "starton") exitWith
{
	// Accept either a BOOL or a Number from the checkbox attribute (it can arrive as 1/0), so the
	// power-on is never skipped just because of the value's type.
	private _startOn = _value in [true, 1];
	_router setVariable ["AE3_power_startOn", _startOn, true];
	if (_dbg) then { diag_log format ["[AE3 DEBUG] [%1] attr_router starton on %2: startOn=%3", time, _router, _startOn]; };
	if (!_startOn) exitWith {};

	// Power the router on once its power initialisation is fully complete (AE3_power_initDone covers
	// the device and its internal battery), so the turn-on never runs against a half-initialised device.
	[
		{
			params ["_router"];
			!alive _router || {
				_router getVariable ["AE3_power_initDone", false] &&
				{!isNil {_router getVariable "AE3_power_fnc_turnOnWrapper"}}
			}
		},
		{
			params ["_router"];
			if (alive _router && {!([_router] call AE3_power_fnc_isPoweredOn)}) then
			{
				private _ok = [_router] call AE3_power_fnc_turnOnDevice;
				if (_dbg) then { diag_log format ["[AE3 DEBUG] [%1] attr_router auto power-on %2: turnOnDevice=%3", time, _router, _ok]; };
			};
		},
		[_router]
	] call CBA_fnc_waitUntilAndExecute;
};

[
	{ params ["_router"]; !isNull _router && {_router getVariable ["AE3_cap_isRouter", false]} },
	{
		params ["_router", "_key", "_value"];
		switch (_key) do
		{
			case "gateway":
			{
				private _gw = [_value] call AE3_network_fnc_str2ip;
				if (_gw isNotEqualTo []) then { _router setVariable ["AE3_network_address", _gw, true]; };
			};
			case "range":      { if (_value > 0) then { _router setVariable ["AE3_network_wirelessRange", _value, true]; }; };
			case "rangemult":  { if (_value >= 0) then { _router setVariable ["AE3_network_rangeMultiplier", _value, true]; }; };
			case "acceptconn": { _router setVariable ["AE3_network_acceptConnections", _value in [true, 1], true]; };
			case "password":   { _router setVariable ["AE3_network_password", _value, true]; };
			case "ssid":       { if (_value isNotEqualTo "") then { _router setVariable ["ace_cargo_customName", _value, true]; }; };
			case "extssh":     { _router setVariable ["AE3_network_allowExternalSsh", _value, true]; };
			case "extallow":   { _router setVariable ["AE3_network_externalAllow", _value, true]; };
		};
	},
	[_router, _key, _value]
] call CBA_fnc_waitUntilAndExecute;
