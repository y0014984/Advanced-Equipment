/*
 * Author: Root
 * Description: Executes the turn off operation for a given computer object. Computer texture changes to show shutdown animation and clears terminal state.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to turn off
 * 1: _silent <BOOL> (Optional, default: false) - Whether to suppress sounds
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_computer_turnOff;
 *
 * Public: Yes
 */

params ["_computer", ["_silent", false]];

[_computer] spawn
{
	params["_computer"];

	private _powerState = _computer getVariable "AE3_power_powerState";

	private _turnOffTime = 0;
	private _elapsedTime = 0;
	private _color = "#(argb,8,8,3)color(0,0,0,0.0,co)";

	// Use CBA setting for shutdown time
	_turnOffTime = AE3_ShutdownTime;

	if (AE3_DebugMode) then { _turnOffTime = 3; };

	for "_i" from 0 to 3 do
	{
		_computer setObjectTextureGlobal [1, format ["\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_%1.paa", _i]];

		sleep (_turnOffTime / 4.0);
		_elapsedTime = _elapsedTime + (_turnOffTime / 4.0);

	};

	_computer setObjectTextureGlobal [1, _color];

	private _handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStop;

	// Clear terminal and sync data
	_computer setVariable ["AE3_terminal", nil];
	_computer setVariable ["AE3_terminal_sync", nil, [clientOwner, 2]];
};

true;
