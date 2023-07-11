/**
 * Turns on the solar panel.
 *
 * Arguments:
 * 0: Solar Panel <OBJECT>
 * 1: If the ace progress bar is shown <BOOL>
 *
 * Returns:
 * None
 */

params ["_entity", ["_silent", false]];

private _result = false;

private _turnOnSolPanFunc =
{
	params ["_entity"];

	[_entity, AE3_power_fnc_solarCalculation] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];
	[_entity, "turnedOn", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
};

if ((!isNull curatorCamera) || (_silent)) then
{
	[_entity] call _turnOnSolPanFunc;
	
	_result = true;
}
else
{
	private _turnOnTime = 3;
	
	[
		_turnOnTime,
		[_entity, _turnOnSolPanFunc], 
		{
			// following code only runs on progress bar success
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_args params ["_entity", "_turnOnSolPanFunc"];

			[_entity] call _turnOnSolPanFunc;

			// we need to set power state here because function already returned false
			// and therefore the turn on wrapper doesn't set the state to turned on
			_entity setVariable ["AE3_power_powerState", 1, true];
		},
		{
			// following code only runs on progress bar fail
		},
		(localize "STR_AE3_Power_Interaction_TurnOn" + "...")
	] call ace_common_fnc_progressBar;
};

_result;