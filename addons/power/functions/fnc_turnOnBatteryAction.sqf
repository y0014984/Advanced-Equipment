/*
 * Turns on the battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Return:
 * None
*/

params['_battery', ['_internal', false]]; 

[_battery, AE3_power_fnc_batteryCalculation, _internal] call AE3_power_fnc_addProviderHandler; 

true;