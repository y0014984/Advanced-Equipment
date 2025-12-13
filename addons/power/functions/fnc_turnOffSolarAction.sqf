/*
 * Author: Root, y0014984, Wasserstoff
 * Description: ACE3 interaction action that turns off a solar panel with progress bar. Removes provider handler, turns off connected devices, and updates interactions. In Zeus mode or if silent, stops immediately without progress bar.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Solar panel object to turn off
 * 1: _silent <BOOL> - (Optional, default: false) Skip progress bar and immediate stop
 *
 * Return Value:
 * Success status (true if immediate stop, false if progress bar started) <BOOL>
 *
 * Example:
 * [_solarPanel, false] call AE3_power_fnc_turnOffSolarAction;
 *
 * Public: No
 */

params ["_entity", ["_silent", false]];

private _result = false;

private _turnOffSolPanFunc =
{
	params ["_entity"];

	[_entity, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
	[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];

	// TODO: Wrapper?
	{
			[_x] call (_x getVariable "AE3_power_fnc_turnOffWrapper");
	}forEach (_entity getVariable ["AE3_power_connectedDevices", []]);
};

if ((!isNull curatorCamera) || (_silent)) then
{
	[_entity] call _turnOffSolPanFunc;

	_result = true;
}
else
{
	private _turnOffTime = 3;

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
};

_result;
