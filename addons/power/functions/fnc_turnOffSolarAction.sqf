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
		("Turn Off")
	] call ace_common_fnc_progressBar;
};

[_entity, true, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;

[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];

// TODO: Wrapper?
{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
}forEach (_entity getVariable ['AE3_power_connectedDevices', []]);

true;