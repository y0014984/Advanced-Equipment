/**
 * Display generator fuel level via hint.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_entity"];

private _result = [_entity] call AE3_power_fnc_getFuelLevel;
_result params ["_fuelLevel", "_fuelLevelPercent", "_fuelCapacity"];

_fuelLevel = [_fuelLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
_fuelLevelPercent = [_fuelLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
_fuelCapacity = [_fuelCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123

hint format ["Fuel Level: %1 l (%2%3 of %4 l)", _fuelLevel, _fuelLevelPercent, "%", _fuelCapacity];