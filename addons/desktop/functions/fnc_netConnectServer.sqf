// File: fnc_netConnectServer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Server-side wireless (re)connect for the web Network app. Disconnects the
 * laptop from its current router (if any) then connects it to the requested router, reusing the
 * authoritative AE3 network functions (which broadcast the new parent/address). Server-only.
 *
 * Arguments:
 * 0: _device <OBJECT> - The laptop
 * 1: _router <OBJECT> - Target router
 * 2: _password <STRING> (Optional, default: "") - Wireless password supplied by the user
 * 3: _owner <NUMBER> (Optional, default: 0) - clientOwner to send the connect result to (0 = none)
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_router", objNull, [objNull]], ["_password", "", [""]], ["_owner", 0, [0]]];

if (!isServer) exitWith {};
if (isNull _device || isNull _router) exitWith {};

private _notify = {
    params ["_ok", "_msg"];
    if (_owner > 0) then { ["ae3_desktop_netResult", [_ok, _msg], _owner] call CBA_fnc_ownerEvent; };
};

// Range + password gate. The scan already filters by range, but re-check on the server so a
// stale/forged request cannot connect out of range or without the right password.
if ((_device distance _router) > (_router getVariable ["AE3_network_wirelessRange", 100])) exitWith {
    [false, "Out of range"] call _notify;
};
if ((_router getVariable ["AE3_power_powerState", 0]) != 1) exitWith {
    [false, "Network offline"] call _notify;
};

private _routerPass = _router getVariable ["AE3_network_password", ""];
if (_routerPass isNotEqualTo "" && _password isNotEqualTo _routerPass) exitWith {
    [false, "Wrong password"] call _notify;
};

if (!isNull (_device getVariable ["AE3_network_parent", objNull])) then {
    [_device] call AE3_network_fnc_disconnect;
};

[_device, _router] call AE3_network_fnc_connect_device2router;
if (_owner > 0) then {
    private _ip = [_device getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str;
    private _gateway = [_router getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str;
    ["ae3_desktop_netResult", [true, format ["Connected: %1", _ip], _ip, _gateway], _owner] call CBA_fnc_ownerEvent;
};
