/**
 * Calculates and sets the new fuel level for a fuel based generator.
 * 
 * Arguments:
 * 0: Generator Object <OBJECT>
 *
 * Returns:
 * 0: Power state <BOOL>
 * 1: Power output <FLOAT>
 */

params ["_generator"];

private _class = typeOf _generator;

private _fuelConsumption = _generator getVariable 'AE3_power_fuelConsumption';
private _fuelCapacity = _generator getVariable 'AE3_power_fuelCapacity';

private _fuelLevelPercent = fuel _generator;
private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

private _fuelLevel = _generator getVariable ["AE3_power_fuelLevel", 0];
private _newFuelLevel = _fuelLevel - (_fuelConsumption / 3600);
private _newFuelLevelPercent = (_newFuelLevel / _fuelCapacity);

if (_newFuelLevel < 0) then
{
	_newFuelLevel = 0;
	_newFuelLevelPercent = 0;
};

_generator setFuel (_newFuelLevelPercent);
_generator setVariable["AE3_power_fuelLevel", _newFuelLevel, true];

if(_newFuelLevel > 0) exitWith 
{
	[true, (_generator getVariable 'AE3_power_powerMax')];
};

[false, 0];