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

if (!_silent) then 
{
	[
		3,
		[_entity], 
		{

		},
		{},
		(localize "STR_AE3_Power_Interaction_TurnOff")
	] call ace_common_fnc_progressBar;
};

[_entity, "turnedOn", false] call AE3_interaction_fnc_manageAce3Interactions;

[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];

// TODO: Wrapper?
{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
}forEach (_entity getVariable ['AE3_power_connectedDevices', []]);

_entity setVariable ['AE3_power_powerCapacity', 0, 2];

true;