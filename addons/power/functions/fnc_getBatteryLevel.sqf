/**
 * Returns the battery level of the given device.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * 0: Battery Level absolute <NUMBER>
 * 1: Battery Level percent <NUMBER>
 * 2: Battery Capacity <NUMBER>
 */

params ["_entity"];

// Update local copy of server var
[_entity] spawn { params ["_entity"]; [_entity, "AE3_power_batteryLevel"] call AE3_main_fnc_getRemoteVar; };

private _batteryLevel = _entity getVariable "AE3_power_batteryLevel";
private _batteryCapacity = _entity getVariable "AE3_power_batteryCapacity";
private _batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;

// Wh
_batteryLevel = _batteryLevel * 1000;
_batteryCapacity = _batteryCapacity * 1000;

[_batteryLevel, _batteryLevelPercent, _batteryCapacity]
