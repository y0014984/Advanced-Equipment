/**
 * Returns the generator fuel level.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * 0: Fuel Level <NUMBER>
 */

params ["_entity"];

private _fuelCapacity = _entity getVariable "AE3_power_fuelCapacity";
private _fuelLevelPercent = fuel _entity;

private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

_fuelLevel