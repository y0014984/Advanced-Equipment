/**
 * PUBLIC - Needs to be executed on the server.
 * 
 * Sets the battery level of a given battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 1: Battery Level Percent <NUMBER>
 * 
 * Example:
 * [battery, 100] call AE3_power_fnc_setBatteryLevel;
 *
 */

params ["_battery", "_batteryLevelPercent"];

if (!isServer) exitWith { false; };

_batteryLevelPercent = ((_batteryLevelPercent min 100) max 0); // normalize; max = 100 and min = 0

private _batteryCapacity = _battery getVariable "AE3_power_batteryCapacity";
private _batteryLevel = _batteryCapacity * (_batteryLevelPercent / 100);

_battery setVariable ["AE3_power_batteryLevel", _batteryLevel];

true;