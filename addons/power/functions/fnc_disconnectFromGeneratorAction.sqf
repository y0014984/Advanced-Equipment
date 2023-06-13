/**
 * Disconnects a device from a power source.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_target"];

[_target] call AE3_power_fnc_removePowerConnection;
