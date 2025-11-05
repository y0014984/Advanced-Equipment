/*
 * Turns on the battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 1: If internal <BOOL> (optional)
 *
 * Return:
 * None
*/

params['_battery', ['_internal', false]]; 

[_battery, AE3_power_fnc_batteryCalculation, _internal] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2]; 

[_battery, "turnedOn", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;
