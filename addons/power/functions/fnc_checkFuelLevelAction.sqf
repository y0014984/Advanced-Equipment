/*
 * Author: Root
 * Description: ACE3 interaction action that displays generator fuel level via hint. Shows fuel in liters, percentage, and total capacity with formatted numbers.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] call AE3_power_fnc_checkFuelLevelAction;
 *
 * Public: No
 */

params ["_entity"];

private _result = [_entity] call AE3_power_fnc_getFuelLevel;
_result params ["_fuelLevel", "_fuelLevelPercent", "_fuelCapacity"];

_fuelLevel = [_fuelLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
_fuelLevelPercent = [_fuelLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
_fuelCapacity = [_fuelCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123

hint format [localize "STR_AE3_Power_Interaction_FuelLevelHint", _fuelLevel, _fuelLevelPercent, "%", _fuelCapacity];
