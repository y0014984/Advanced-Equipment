/*
 * Author: Root
 * Description: ACE3 interaction action that turns off a battery by removing its provider handler. Stops battery calculation loop, turns off all connected devices, and updates ACE3 interactions to show "turned off" state.
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object to turn off
 *
 * Return Value:
 * Success status (always true) <BOOL>
 *
 * Example:
 * [_battery] call AE3_power_fnc_turnOffBatteryAction;
 *
 * Public: No
 */

params['_battery'];

[_battery] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2]; 

{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
}forEach (_battery getVariable ['AE3_power_connectedDevices', []]);

[_battery, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;
