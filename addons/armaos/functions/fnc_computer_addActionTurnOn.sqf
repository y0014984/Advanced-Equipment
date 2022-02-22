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



private _powerState = _computer getVariable 'AE3_power_powerState';

private _turnOnTime = 0;

if (_powerState == 0) then
{
	_turnOnTime = 15; 
}
else
{
	_turnOnTime = 3;
};

_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_0.paa"];
_computer setVariable ["_bootingTextureIndex", 0];

[
	_turnOnTime,
	[_computer], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		private _computer = _args select 0;

		_computer setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_On.paa"];

		private _handle = [_computer] spawn AE3_armaos_fnc_computer_playSoundStart;
	},
	{},
	"Booting",
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

		private _computer = _args select 0;

		private _bootingTextureIndex = _computer getVariable ["_bootingTextureIndex", -1];

		private _elapsedTimePercent = _elapsedTime / _totalTime;

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


true;