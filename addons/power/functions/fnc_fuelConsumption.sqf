/*
 * Author: Root, Wasserstoff
 * Description: Calculates and updates the fuel level for a fuel-powered generator. Called every second by the power provider handler. Consumes fuel based on the configured consumption rate and returns whether the generator can still run. Fuel consumption is in liters per hour, converted to per-second rate.
 *
 * Arguments:
 * 0: _generator <OBJECT> - Generator object
 *
 * Return Value:
 * [Power state (true if fuel remaining), Power output in kWh] <ARRAY>
 *
 * Example:
 * private _genStatus = [_generator] call AE3_power_fnc_fuelConsumption;
 *
 * Public: Yes
 */

params ["_generator"];

private _class = typeOf _generator;

private _fuelConsumption = _generator getVariable 'AE3_power_fuelConsumption';
private _fuelCapacity = _generator getVariable 'AE3_power_fuelCapacity';

private _fuelLevelPercent = fuel _generator;
private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

private _newFuelLevel = _fuelLevel - (_fuelConsumption / 3600);
private _newFuelLevelPercent = (_newFuelLevel / _fuelCapacity);

if (_newFuelLevel < 0) then
{
	_newFuelLevel = 0;
	_newFuelLevelPercent = 0;
};

_generator setFuel (_newFuelLevelPercent);

if(_newFuelLevel > 0) exitWith 
{
	[true, (_generator getVariable 'AE3_power_powerMax')];
};

[false, 0];
