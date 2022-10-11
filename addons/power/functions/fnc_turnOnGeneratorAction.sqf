/**
 * Turns on the generator.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity"];

private _fuelCapacity = _entity getVariable 'AE3_power_fuelCapacity';
private _fuelLevelPercent = fuel _entity;
private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

if (_fuelLevel > 0) then
{
	_turnOnTime = 5;

	_handle = [_entity] spawn AE3_power_fnc_playGeneratorStartSound;

	[
		_turnOnTime,
		[_entity], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_entity = _args select 0;

			[_entity, AE3_power_fnc_fuelConsumption] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];

			[_entity, false, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;
		},
		{},
		("Turn on")
	] call ace_common_fnc_progressBar;
};

true;