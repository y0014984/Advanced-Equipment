/**
 * Turns on the solar panel.
 *
 * Arguments:
 * 0: Solar Panel <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity"];

private _result = false;

private _turnOnTime = 3;

[
	_turnOnTime,
	[_entity], 
	{
		// following code only runs on progress bar success
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_args params ["_entity"];

		[_entity, AE3_power_fnc_solarCalculation] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];

		[_entity, false, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;

		// we need to set power state here because function already returned false
		// and therefore the turn on wrapper doesn't set the state to turned on
		_entity setVariable ["AE3_power_powerState", 1, true];
	},
	{
		// following code only runs on progress bar fail
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_args params ["_entity"];
	},
	(localize "STR_AE3_Power_Interaction_TurnOn" + "...")
] call ace_common_fnc_progressBar;

// function immediately returns false, because progress bar runs unscheduled
_result;