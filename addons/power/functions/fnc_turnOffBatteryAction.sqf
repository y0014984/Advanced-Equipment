/*
 * Turns off the battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Return:
 * None
*/

params['_battery'];

[_battery] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2]; 

{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
}forEach (_battery getVariable ['AE3_power_connectedDevices', []]);

[_battery, "turnedOn", false] call AE3_interaction_fnc_manageAce3Interactions;

true;