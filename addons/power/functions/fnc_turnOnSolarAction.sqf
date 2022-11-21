/**
 * Turns on the solar panel.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity"];

[
3,
[_entity], 
{
	params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
	
	_entity = _args select 0;

	[_entity, AE3_power_fnc_solarCalculation] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];

	[_entity, false, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;
},
{},
(localize "STR_AE3_Power_Interaction_TurnOn")
] call ace_common_fnc_progressBar;

true;