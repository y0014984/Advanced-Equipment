// File: fnc_setSshEnabled.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sets whether a device accepts incoming SSH sessions and broadcasts the flag. Exists so
 * clients (Zeus attributes, the desktop Settings panel) have a named function to route to the server
 * instead of remote-executing the raw setVariable command, which needs its own exclusion to pass the
 * remote execution filters used on dedicated servers.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device to configure
 * 1: _enabled <BOOL> - Whether incoming SSH sessions are accepted
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, true] remoteExecCall ["AE3_network_fnc_setSshEnabled", 2];
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_enabled", false, [false]]];

if (!isServer) exitWith {};
if (isNull _device) exitWith {};

_device setVariable ["AE3_ssh_enabled", _enabled, true];
