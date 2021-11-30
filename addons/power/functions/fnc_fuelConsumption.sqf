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

private _fuelConsumption = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_fuelConsumption");
private _fuelCapacity = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_fuelCapacity");

private _fuelLevelPercent = fuel _generator;
private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

private _fuelLevel = _generator getVariable ["AE3_fuelLevel", 0];
private _newFuelLevel = _fuelLevel - (_fuelConsumption / 3600);
private _newFuelLevelPercent = (_newFuelLevel / _fuelCapacity);

if (_newFuelLevel < 0) then
{
	_newFuelLevel = 0;
	_newFuelLevelPercent = 0;
};

_generator setFuel (_newFuelLevelPercent);
_generator setVariable["AE3_fuelLevel", _newFuelLevel];

if(_newFuelLevel > 0) exitWith 
{
	[true, 400];
};

[false, 0];