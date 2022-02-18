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

private _powerState = _computer getVariable 'AE3_power_powerState';

private _turnOffTime = 0;

if (_powerState == 1) then
{
	_turnOffTime = 15;
}
else
{
	_turnOffTime = 10;
};

private _color = "#(argb,8,8,3)color(0,0,0,0.0,co)";

if (_silent) then 
{
			_computer setObjectTextureGlobal [1, _color];
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
			
			private _computer = _args select 0;
			private _color = _args select 1;

			_computer setObjectTextureGlobal [1, _color];

			private _handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStop;

			private _terminal = _computer getVariable "AE3_terminal";

			_terminal set ["AE3_terminalCommandHistory", []];
		},
		{},
		"Shutdown",
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

			private _computer = _args select 0;

			private _shuttingDownTextureIndex = _computer getVariable ["_shuttingDownTextureIndex", -1];

			private _elapsedTimePercent = _elapsedTime / _totalTime;

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

true;