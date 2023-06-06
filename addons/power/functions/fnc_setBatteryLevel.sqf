/**
 * Sets the battery level of a given battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 0: Battery Level Percent <NUMBER>
 * 
 */

params ["_battery", "_batteryLevelPercent"];

private _batteryCapacity = _battery getVariable "AE3_power_batteryCapacity";
private _batteryLevel = _batteryCapacity * (_batteryLevelPercent / 100);

_battery setVariable ["AE3_power_batteryLevel", _batteryLevel];