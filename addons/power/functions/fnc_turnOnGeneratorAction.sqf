/**
 * Turns on the generator.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: If the ace progress bar is shown <BOOL>
 *
 * Returns:
 * None
 */

params ["_entity", ["_silent", false]];

private _result = false;

private _startSoundHandle = scriptNull;

private _turnOnGenFunc =
{
	params ["_entity", "_startSoundHandle"];

	[_entity, AE3_power_fnc_fuelConsumption] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];
	[_entity, "turnedOn", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

	_startSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStartSound;
};

if ((!isNull curatorCamera) || (_silent)) then
{
	[_entity] call _turnOnGenFunc;

	_result = true;
}
else
{
	private _turnOnTime = 5;

	private _fuelCapacity = _entity getVariable "AE3_power_fuelCapacity";
	private _fuelLevelPercent = fuel _entity;
	private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

	if (_fuelLevel > 0) then
	{
		[
			_turnOnTime,
			[_entity, _startSoundHandle, _turnOnGenFunc], 
			{
				// following code only runs on progress bar success
				params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
				
				_args params ["_entity", "_startSoundHandle", "_turnOnGenFunc"];

				[_entity, _startSoundHandle] call _turnOnGenFunc;

				// we need to set power state here because function already returned false
				// and therefore the turn on wrapper doesn't set the state to turned on
				_entity setVariable ["AE3_power_powerState", 1, true];
			},
			{
				// following code only runs on progress bar fail
				params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

				_args params ["_entity", "_startSoundHandle", "_turnOnGenFunc"];
				
				// start sound will be canceled
				terminate _startSoundHandle;

				// stop sound will be played
				private _stopSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStopSound;
			},
			(localize "STR_AE3_Power_Interaction_TurnOn" + "...")
		] call ace_common_fnc_progressBar;
	};
};

// function immediately returns false, because progress bar runs unscheduled
_result;