/**
 * Display battery charging level via hint.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Returns:
 * None
 */

params["_entity"];

private _result = [_entity] call AE3_power_fnc_getBatteryLevel;

_result params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];

hint format ["Battery Level: %1 Wh (%2%3 of %4 Wh)", _batteryLevel, _batteryLevelPercent, "%", _batteryCapacity];