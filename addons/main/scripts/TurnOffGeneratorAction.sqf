params ["_entity", "_silent"];

_powerState = _entity getVariable "AE3_powerState";

_turnOffTime = 3;

_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PlayGeneratorStopSound.sqf";

_handle = _entity getVariable "AE3_generatorRunningSoundHandle";
terminate _handle;

if (_silent) then 
{	
			_entity setVariable ["AE3_powerState", 0, true];

			[_entity, true, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;
}
else 
{
	[
		_turnOffTime,
		[_entity], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_entity = _args select 0;

			_entity setVariable ["AE3_powerState", 0, true];

			[_entity, true, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;
		},
		{},
		("Turn Off")
	] call ace_common_fnc_progressBar;
};