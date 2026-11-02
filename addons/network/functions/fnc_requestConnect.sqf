#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Wireless connect requested by a player. Runs AE3_network_fnc_canConnect with the password, then
 * moves the device to the router and reports the result to the requesting client: "app" sends
 * ae3_desktop_netResult to the Network app, "ace" sends ae3_network_connectResult (shown as a hint). Routed to
 * the server from any machine.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device
 * 1: _router <OBJECT> - The router
 * 2: _password <STRING> - (Optional, default: "") Password entered by the player
 * 3: _owner <NUMBER> - (Optional, default: 0) clientOwner to report to (0 = none)
 * 4: _source <STRING> - (Optional, default: "app") "app" | "ace"
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, _router, "secret", clientOwner, "ace"] call AE3_network_fnc_requestConnect;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]], ["_router", objNull, [objNull]], ["_password", "", [""]], ["_owner", 0, [0]], ["_source", "app", [""]]];

if (!isServer) exitWith {
    ["ae3_network_requestConnect", [netId _device, netId _router, _password, _owner, _source]] call CBA_fnc_serverEvent;
};

if (isNull _device || {isNull _router}) exitWith {};

private _notify = {
    params ["_ok", "_msg", ["_ip", ""], ["_gateway", ""]];
    if (_owner <= 0) exitWith {};
    if (_source isEqualTo "ace") then {
        ["ae3_network_connectResult", [_ok, _msg], _owner] call CBA_fnc_ownerEvent;
    } else {
        ["ae3_desktop_netResult", [_ok, _msg, _ip, _gateway], _owner] call CBA_fnc_ownerEvent;
    };
};

([_device, _router, _password] call FUNC(canConnect)) params ["_allowed", "_reason"];
if (!_allowed) exitWith { [false, _reason] call _notify; };

if (!isNull (_device getVariable ["AE3_network_parent", objNull])) then {
    [_device] call FUNC(disconnect);
};

[_device, _router] call FUNC(connect_device2router);

private _ip = [_device getVariable ["AE3_network_address", [127, 0, 0, 1]]] call FUNC(ip2str);
private _gateway = [_router getVariable ["AE3_network_address", [127, 0, 0, 1]]] call FUNC(ip2str);
[true, format ["Connected: %1", _ip], _ip, _gateway] call _notify;
