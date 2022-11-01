/**
 * Get battery charging level. Returns as Wh and Percent.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Returns:
 * 0: Battery Level <FLOAT>
 * 1: Batttery Level Percent <FLOAT>
 * 
 */

params ["_battery"];

[_battery, "AE3_power_batteryLevel"] call AE3_main_fnc_getRemoteVar;

private _batteryLevel = _battery getVariable "AE3_power_batteryLevel";
private _batteryCapacity = _battery getVariable "AE3_power_batteryCapacity";
private _batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;

[_batteryLevel * 1000, _batteryLevelPercent]