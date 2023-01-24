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

private _fuelCapacity = _entity getVariable "AE3_power_fuelCapacity";
private _fuelLevelPercent = fuel _entity;
private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

private _result = false;

if (_fuelLevel > 0) then
{
	private _turnOnTime = 5;

	private _startSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStartSound;

	[
		_turnOnTime,
		[_entity, _startSoundHandle], 
		{
			// following code only runs on progress bar success
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_startSoundHandle"];

			[_entity, AE3_power_fnc_fuelConsumption] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];

			[_entity, false, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;

			// we need to set power state here because function already returned false
			// and therefore the turn on wrapper doesn't set the state to turned on
			_entity setVariable ["AE3_power_powerState", 1, true];
		},
		{
			// following code only runs on progress bar fail
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

			_args params ["_entity", "_startSoundHandle"];
			
			// start sound will be canceled
			terminate _startSoundHandle;

			// stop sound will be played
			private _stopSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStopSound;
		},
		(localize "STR_AE3_Power_Interaction_TurnOn" + "...")
	] call ace_common_fnc_progressBar;
};

// function immediately returns false, because progress bar runs unscheduled
_result;