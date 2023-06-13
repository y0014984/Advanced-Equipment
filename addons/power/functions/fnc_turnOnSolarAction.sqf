/**
 * Turns on the solar panel.
 *
 * Arguments:
 * 0: Solar Panel <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity", ["_silent", false]];

private _result = false;

private _turnOnTime = 3;

private _turnOnFnc = {
	params['_entity'];

	[_entity, AE3_power_fnc_solarCalculation] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];
	[_entity, "turnedOn", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

	// we need to set power state here because function already returned false
	// and therefore the turn on wrapper doesn't set the state to turned on
	_entity setVariable ["AE3_power_powerState", 1, true];
};

if (!_silent) then {
	[
		_turnOnTime,
		[_entity, _turnOnFnc], 
		{
			// following code only runs on progress bar success
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_turnOnFnc"];

			[_entity] call _turnOnFnc;
		},
		{
			// following code only runs on progress bar fail
		},
		(localize "STR_AE3_Power_Interaction_TurnOn" + "...")
	] call ace_common_fnc_progressBar;
}else
{
	[_entity] call _turnOnFnc;
};

// function immediately returns false, because progress bar runs unscheduled
_result;