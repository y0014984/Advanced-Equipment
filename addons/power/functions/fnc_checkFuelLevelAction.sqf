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

private _fuelCapacity = _entity getVariable 'AE3_power_fuelCapacity';
private _fuelLevelPercent = fuel _entity;

private _fuelLevel = _fuelCapacity * _fuelLevelPercent;
hint format ["Fuel Level: %1 l", _fuelLevel];
