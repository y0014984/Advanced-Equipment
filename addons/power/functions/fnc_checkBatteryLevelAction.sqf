/**
 * Display battery charging level via hint.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Returns:
 * None
 * 
 */

params["_entity"];

private _result = [_entity] call AE3_power_fnc_getBatteryLevel;
_result params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];

_batteryLevel = [_batteryLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
_batteryLevelPercent = [_batteryLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
_batteryCapacity = [_batteryCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123

hint format [localize "STR_AE3_Power_Interaction_BatteryLevelHint", _batteryLevel, _batteryLevelPercent, "%", _batteryCapacity];
