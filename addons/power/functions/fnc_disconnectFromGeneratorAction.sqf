/**
 * PRIVATE
 *
 * Disconnects a device from it's power source. This function is triggered by a ACE3 interaction.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_target"];

[_target] call AE3_power_fnc_removePowerConnection;
