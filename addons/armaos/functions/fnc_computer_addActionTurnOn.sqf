/**
 * Adds the "turn on" ACE interaction for a given computer object. Computer texture changes accordingly.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

_batteryLevel = _computer getVariable "AE3_batteryLevel";

if (_batteryLevel > 0) then
{
	_powerState = _computer getVariable 'AE3_powerState';

	_turnOnTime = 0;

	switch (_powerState) do
	{
		case 0: { _turnOnTime = 15; };
		case 2: { _turnOnTime = 3; };
		default {};
	};

	_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_0.paa"];
	_computer setVariable ["_bootingTextureIndex", 0];

	[
		_turnOnTime,
		[_computer], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_computer = _args select 0;

			_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_On.paa"];

			_handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStart;

			_computer setVariable ['AE3_powerState', 1, true];

		},
		{},
		"Booting",
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

			_computer = _args select 0;

			_bootingTextureIndex = _computer getVariable ["_bootingTextureIndex", -1];

			_elapsedTimePercent = _elapsedTime / _totalTime;

			switch (true) do
			{
				case ((_elapsedTimePercent >= 0.25) && (_bootingTextureIndex < 1)):
				{
					_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_1.paa"];
					_computer setVariable ["_bootingTextureIndex", 1];
				};
				case ((_elapsedTimePercent >= 0.5) && (_bootingTextureIndex < 2)):
				{
					_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_2.paa"];
					_computer setVariable ["_bootingTextureIndex", 2];
				};
				case ((_elapsedTimePercent >= 0.75) && (_bootingTextureIndex < 3)):
				{
					_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_3.paa"];
					_computer setVariable ["_bootingTextureIndex", 3];
				};
			};
		}
	] call ace_common_fnc_progressBar;
};