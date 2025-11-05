/**
 * Returns the generator fuel level.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * 0: Fuel Level absolute <NUMBER>
 * 1: Fuel Level percent <NUMBER>
 * 2: Fuel Capacity <NUMBER>
 */

params ["_entity"];

private _fuelCapacity = _entity getVariable "AE3_power_fuelCapacity";
private _fuelLevelPercent = fuel _entity;

private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

_fuelLevelPercent = _fuelLevelPercent * 100;

[_fuelLevel, _fuelLevelPercent, _fuelCapacity]
