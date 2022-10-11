/*
 * Turns off the battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Return:
 * None
*/

params['_entity'];

[_entity] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2]; 

{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
}forEach (_entity getVariable ['AE3_power_connectedDevices', []]);

true;