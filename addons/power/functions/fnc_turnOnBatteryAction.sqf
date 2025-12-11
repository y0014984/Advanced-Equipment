/*
 * Author: Root
 * Description: ACE3 interaction action that turns on a battery by adding its provider handler. Starts battery calculation loop and updates ACE3 interactions to show "turned on" state.
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object to turn on
 * 1: _internal <BOOL> - (Optional, default: false) Whether this is an internal battery
 *
 * Return Value:
 * Success status (always true) <BOOL>
 *
 * Example:
 * [_battery, false] call AE3_power_fnc_turnOnBatteryAction;
 *
 * Public: No
 */

params['_battery', ['_internal', false]]; 

[_battery, AE3_power_fnc_batteryCalculation, _internal] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2]; 

[_battery, "turnedOn", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;
