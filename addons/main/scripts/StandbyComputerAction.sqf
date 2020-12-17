params ["_entity"];

_standbyTime = 3;

[
	_standbyTime,
	[_entity], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_entity = _args select 0;

		_entity setObjectTextureGlobal [1, "\z\ae3\addons\main\textures\Laptop_4_to_3_Standby.paa"];

		_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PlayComputerStandbySound.sqf";

		_entity setVariable ['AE3_powerState', 1, true];
	},
	{},
	("Standby")
] call ace_common_fnc_progressBar;