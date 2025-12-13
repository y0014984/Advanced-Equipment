/*
 * Author: Root, y0014984, Wasserstoff
 * Description: ACE3 interaction action wrapper that disconnects a device from its power source. Calls removePowerConnection to handle the disconnection logic.
 *
 * Arguments:
 * 0: _target <OBJECT> - Device to disconnect
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_power_fnc_disconnectFromGeneratorAction;
 *
 * Public: No
 */

params ["_target"];

[_target] call AE3_power_fnc_removePowerConnection;
