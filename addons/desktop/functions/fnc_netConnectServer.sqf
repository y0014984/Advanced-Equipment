// File: fnc_netConnectServer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Server-side wireless connect for the web Network app. Checks and connects through
 * AE3_network_fnc_requestConnect and reports the result to the Network app. Server-only.
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

[_device, _router, _password, _owner, "app"] call AE3_network_fnc_requestConnect;
