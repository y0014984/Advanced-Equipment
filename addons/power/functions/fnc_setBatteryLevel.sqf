/*
 * Author: Root
 * Description: Sets the battery level of a given battery to a specified percentage. Must be executed on the server. The value is automatically clamped between 0 and 100 percent.
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object to modify
 * 1: _batteryLevelPercent <NUMBER> - Battery level in percent (0-100)
 *
 * Return Value:
 * Success status <BOOL>
 *
 * Example:
 * [_battery, 100] call AE3_power_fnc_setBatteryLevel;
 * [_battery, 50] remoteExecCall ["AE3_power_fnc_setBatteryLevel", 2];
 *
 * Public: Yes
 */

params ["_battery", "_batteryLevelPercent"];

if (!isServer) exitWith { false; };

_batteryLevelPercent = ((_batteryLevelPercent min 100) max 0); // normalize; max = 100 and min = 0

private _batteryCapacity = _battery getVariable "AE3_power_batteryCapacity";
private _batteryLevel = _batteryCapacity * (_batteryLevelPercent / 100);

_battery setVariable ["AE3_power_batteryLevel", _batteryLevel];

true;
