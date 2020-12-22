params ["_entity"];

_fuelLevel = _entity getVariable "AE3_fuelLevel";

if (_fuelLevel > 0) then
{
	_turnOnTime = 3;

	_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PlayGeneratorStartSound.sqf";

	[
		_turnOnTime,
		[_entity], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_entity = _args select 0;

			_entity setVariable ["AE3_powerState", 1, true];

			_connectedDevices = _entity getVariable ["AE3_connectedDevices", []];

			{
				_powerState = _x getVariable ["AE3_powerState", 0];
				if (_powerState == 0) then { _x setVariable ["AE3_powerState", 1, true]; };
			} forEach _connectedDevices;

			[_entity, false, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;
		},
		{},
		("Turn on")
	] call ace_common_fnc_progressBar;
};