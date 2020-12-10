params ["_entity"];

_powerState = _entity getVariable 'AE3_powerState';

_turnOnTime = 3;

[
	_turnOnTime,
	[_entity], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_entity = _args select 0;

		_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PlayGeneratorStartSound.sqf";
		
		_entity setVariable ["AE3_powerState", 1, true];

		[_entity, false, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;
	},
	{},
	("Turn on")
] call ace_common_fnc_progressBar;