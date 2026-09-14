// File: fnc_applyRouterConfig.sqf
/*
 * Author: Root
 * Description: Applies wireless configuration to a router and broadcasts it: network name,
 * wireless range, password, and gateway. Shared by the router admin page and attribute dialogs.
 *
 * Arguments:
 * 0: _router <OBJECT> - The router object
 * 1: _name <STRING> - New network name (blank = leave unchanged)
 * 2: _range <NUMBER> - Wireless range in metres (<= 0 = leave unchanged)
 * 3: _password <STRING> - Network password ("" = open network)
 * 4: _gateway <STRING|ARRAY> - New default gateway as "a.b.c.d" or [a,b,c,d] (blank/invalid = unchanged)
 * 5: _allowExternal <BOOL> - (Optional, default: false) Allow ping/SSH from other gateways
 * 6: _externalAllow <STRING> - (Optional, default: "") Comma/space separated regex of allowed source gateways (blank = any)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_router, "Cafe Wifi", 80, "latte", "10.0.0.1", true, "192\.168\.1\..*"] call AE3_network_fnc_applyRouterConfig;
 *
 * Public: Yes
 */

params [["_router", objNull, [objNull]], ["_name", "", [""]], ["_range", 0, [0]], ["_password", "", [""]], ["_gateway", "", ["", []]], ["_allowExternal", false, [false]], ["_externalAllow", "", [""]]];

if (!isServer) exitWith {};
if (isNull _router) exitWith {};

if (_name isNotEqualTo "") then { _router setVariable ["ace_cargo_customName", _name, true]; };
if (_range > 0) then { _router setVariable ["AE3_network_wirelessRange", _range, true]; };
_router setVariable ["AE3_network_password", _password, true];
_router setVariable ["AE3_network_allowExternalSsh", _allowExternal, true];
_router setVariable ["AE3_network_externalAllow", _externalAllow, true];

// Default gateway = the router's own base address; DHCP (AE3_network_fnc_dhcp_get) hands out client
// IPs from it. Accept "a.b.c.d" or [a,b,c,d]; ignore anything that isn't 4 octets in 0..255.
private _gw = [];
if (_gateway isEqualType "") then {
    if (_gateway isNotEqualTo "") then { _gw = (_gateway splitString ".") apply { parseNumber _x }; };
} else {
    _gw = _gateway;
};
if (count _gw == 4 && {(_gw findIf { if !(_x isEqualType 0) exitWith {true}; _x < 0 || _x > 255 }) == -1}) then {
    _router setVariable ["AE3_network_address", _gw, true];
};

// Nudge any open desktop System/Network panel to re-read the updated wireless settings live.
["ae3_desktop_sysChanged", []] call CBA_fnc_globalEvent;
