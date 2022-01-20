/**
 * Adds the "turn off" ACE interaction for a given computer object. Computer texture changes accordingly if silent mode is false.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Silent Switch <BOOL>
 *
 * Results:
 * None
 */

params ["_computer", "_silent"];

_powerState = _computer getVariable 'AE3_powerState';

_turnOffTime = 0;

switch (_powerState) do
{
	case 1: { _turnOffTime = 15; };
	case 2: { _turnOffTime = 10; };
	default {};
};

_color = "#(argb,8,8,3)color(0,0,0,0.0,co)";

if (_silent) then 
{
			_computer setObjectTextureGlobal [1, _color];
			_computer setVariable ['AE3_powerState', 0, true];
}
else 
{
	_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_0.paa"];
	_computer setVariable ["_shuttingDownTextureIndex", 0];

	[
		_turnOffTime,
		[_computer, _color], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_computer = _args select 0;
			_color = _args select 1;

			_computer setObjectTextureGlobal [1, _color];

			_handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStop;

			_computer setVariable ['AE3_powerState', 0, true];

			_computer setVariable ["history", [], true];
		},
		{},
		"Shutdown",
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

			_computer = _args select 0;

			_shuttingDownTextureIndex = _computer getVariable ["_shuttingDownTextureIndex", -1];

			_elapsedTimePercent = _elapsedTime / _totalTime;

			switch (true) do
			{
				case ((_elapsedTimePercent >= 0.25) && (_shuttingDownTextureIndex < 1)):
				{
					_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_1.paa"];
					_computer setVariable ["_shuttingDownTextureIndex", 1];
				};
				case ((_elapsedTimePercent >= 0.5) && (_shuttingDownTextureIndex < 2)):
				{
					_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_2.paa"];
					_computer setVariable ["_shuttingDownTextureIndex", 2];
				};
				case ((_elapsedTimePercent >= 0.75) && (_shuttingDownTextureIndex < 3)):
				{
					_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_3.paa"];
					_computer setVariable ["_shuttingDownTextureIndex", 3];
				};
			};
		}
	] call ace_common_fnc_progressBar;
};