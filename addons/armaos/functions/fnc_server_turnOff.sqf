// File: fnc_server_turnOff.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Power-off action of headless servers. Clears any terminal state left by SSH sessions
 * without touching model textures (servers have no screen).
 *
 * Arguments:
 * 0: _computer <OBJECT> - The server
 * 1: _silent <BOOL> (Optional, default: false) - Skip the shutdown sound
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_server] call AE3_armaos_fnc_server_turnOff;
 *
 * Public: No
 */

params ["_computer", ["_silent", false]];

if (!_silent) then
{
	[_computer] call AE3_armaos_fnc_computer_playSoundStop;
};

_computer setVariable ["AE3_terminal", nil];
_computer setVariable ["AE3_terminal_sync", nil, [clientOwner, 2]];

true
