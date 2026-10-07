// File: fnc_turnOffGeneratorAction.sqf
/*
 * Author: Root, y0014984, Wasserstoff
 * Description: ACE3 interaction action that turns off a fuel generator with progress bar and sound effects. Removes provider handler, plays stop sound, turns off connected devices, and updates interactions. In Zeus mode or if silent, stops immediately without progress bar. Handles progress bar cancellation with restart sound.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object to turn off
 * 1: _silent <BOOL> - (Optional, default: false) Skip progress bar and immediate stop
 *
 * Return Value:
 * Success status (true if immediate stop, false if progress bar started) <BOOL>
 *
 * Example:
 * [_generator, false] call AE3_power_fnc_turnOffGeneratorAction;
 *
 * Public: No
 */

params ["_entity", ["_silent", false]];

private _result = false;

// Removes the generator as a provider and turns off its devices. The stop sound is spawned here only
// when the caller has not already started it (the progress bar path starts it together with the bar).
private _turnOffGenFunc =
{
	params ["_entity", ["_soundStarted", false]];

	[_entity, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
	[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];

	if (!_soundStarted) then { [_entity] spawn AE3_power_fnc_playGeneratorStopSound; };

	// TODO: Wrapper?
	{
			[_x] call (_x getVariable "AE3_power_fnc_turnOffWrapper");
	}forEach (_entity getVariable ["AE3_power_connectedDevices", []]);
};

if ((!isNull curatorCamera) || (_silent)) then
{
	[_entity] call _turnOffGenFunc;

	_result = true;
}
else
{
	private _turnOffTime = 3;

	// The stop sound runs alongside the progress bar; a cancelled bar terminates it and plays the
	// start sound, which restores the running loop.
	private _stopSoundHandle = [_entity] spawn AE3_power_fnc_playGeneratorStopSound;

	[
		_turnOffTime,
		[_entity, _stopSoundHandle, _turnOffGenFunc], 
		{
			// following code only runs on progress bar success
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "", "_turnOffGenFunc"];

			[_entity, true] call _turnOffGenFunc;

			// we need to set power state here because function already returned false
			// and therefore the turn on wrapper doesn't set the state to turned on
			_entity setVariable ["AE3_power_powerState", 0, true];
		},
		{
			// following code only runs on progress bar fail
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_stopSoundHandle", "_turnOffGenFunc"];

			// stop sound will be canceled
			terminate _stopSoundHandle;

			// start sound will be played
			[_entity] spawn AE3_power_fnc_playGeneratorStartSound;
		},
		(localize "STR_AE3_Power_Interaction_TurnOff" + "...")
	] call ace_common_fnc_progressBar;
};

// function immediately returns false, because progress bar runs unscheduled
_result;
