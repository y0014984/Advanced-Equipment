// File: fnc_server_turnOn.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Power-on action of headless servers. Servers have no screen or local interface, so
 * unlike AE3_armaos_fnc_computer_turnOn no boot animation or textures are applied; the device is
 * reachable over the network (SSH, desktop SSH app) as soon as it is on.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The server
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_server] call AE3_armaos_fnc_server_turnOn;
 *
 * Public: No
 */

params ["_computer"];

[_computer] call AE3_armaos_fnc_computer_playSoundStart;

true
