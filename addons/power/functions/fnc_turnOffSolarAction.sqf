/*
 * Turns off the solar panel.
 *
 * Arguments:
 * 0: Solar panel <OBJECT>
 * 1: If the ace progress bar is shown <BOOL>
 * 
 * Return:
 * None
*/

params ["_entity", ["_silent", false]];

private _result = false;

private _turnOffTime = 3;

private _turnOffSolPanFunc =
{
	params ["_entity"];

	[_entity, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

	[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];

	// TODO: Wrapper?
	{
			[_x] call (_x getVariable "AE3_power_fnc_turnOffWrapper");
	}forEach (_entity getVariable ["AE3_power_connectedDevices", []]);

	_entity setVariable ["AE3_power_powerCapacity", 0, 2];
};

if (!_silent) then 
{
	[
		_turnOffTime,
		[_entity, _turnOffSolPanFunc], 
		{
			// following code only runs on progress bar success
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_turnOffSolPanFunc"];

			[_entity] call _turnOffSolPanFunc;

			// we need to set power state here because function already returned false
			// and therefore the turn on wrapper doesn't set the state to turned on
			_entity setVariable ["AE3_power_powerState", 0, true];
		},
		{
			// following code only runs on progress bar fail
		},
		(localize "STR_AE3_Power_Interaction_TurnOff" + "...")
	] call ace_common_fnc_progressBar;
}
else
{
	[_entity] call _turnOffSolPanFunc;

	_result = true;
};

// function immediately returns false, because progress bar runs unscheduled
_result;