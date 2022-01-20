/**
 * Adds the "standby" ACE interaction for a given computer object. Computer texture changes accordingly.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

_standbyTime = 3;

[
	_standbyTime,
	[_computer], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_computer = _args select 0;

		_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Standby.paa"];

		_handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStandby;

		_computer setVariable ['AE3_powerState', 2, true];
	},
	{},
	("Standby")
] call ace_common_fnc_progressBar;