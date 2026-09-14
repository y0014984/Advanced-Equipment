// File: fnc_computer_setHostname.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Renames a device and broadcasts the new name. The hostname doubles as the display name
 * used by ACE cargo, the network scan and the terminal prompt. Exists so clients (Zeus attributes)
 * have a named function to route to the server instead of remote-executing the raw setVariable
 * command, which needs its own exclusion to pass the remote execution filters used on dedicated
 * servers. A blank name leaves the current one untouched.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The device to rename
 * 1: _hostname <STRING> - The new hostname
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "ops-01"] remoteExecCall ["AE3_armaos_fnc_computer_setHostname", 2];
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_hostname", "", [""]]];

if (!isServer) exitWith {};
if (isNull _computer) exitWith {};

_hostname = trim _hostname;
if (_hostname isEqualTo "") exitWith {};

_computer setVariable ["ace_cargo_customName", _hostname, true];
