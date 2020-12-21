params ["_entity"];

_batteryLevel = _entity getVariable "AE3_batteryLevel";

if (_batteryLevel > 0) then
{
	_powerState = _entity getVariable 'AE3_powerState';

	_turnOnTime = 0;

	switch (_powerState) do
	{
		case 0: { _turnOnTime = 15; };
		case 1: { _turnOnTime = 3; };
		default {};
	};

	_entity setObjectTextureGlobal [1, "\z\ae3\addons\main\textures\Laptop_4_to_3_Booting.paa"];

	[
		_turnOnTime,
		[_entity], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_entity = _args select 0;

			_entity setObjectTextureGlobal [1, "\z\ae3\addons\main\textures\Laptop_4_to_3_On.paa"];

			_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PlayComputerStartSound.sqf";

			_entity setVariable ['AE3_powerState', 2, true];

		},
		{},
		("Booting")
	] call ace_common_fnc_progressBar;
};