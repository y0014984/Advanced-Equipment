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

private _fuelLevel = [_entity] call AE3_power_fnc_getFuelLevel;
_fuelLevel = [_fuelLevel, 1, 2] call CBA_fnc_formatNumber; 
hint format ["Fuel Level: %1 l", _fuelLevel];
