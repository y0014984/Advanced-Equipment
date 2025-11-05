/**
 * PUBLIC
 *
 * Sets the fuel level of a given generator.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: Fuel Level Percent <NUMBER>
 * 
 * Example:
 * [generator, 100] call AE3_power_fnc_setFuelLevel;
 *
 */

params ["_generator", "_fuelLevelPercent"];

_fuelLevelPercent = ((_fuelLevelPercent min 100) max 0); // normalize; max = 100 and min = 0

private _fuelCapacity = _generator getVariable "AE3_power_batteryCapacity";
private _fuelLevel = _fuelLevelPercent / 100;

_generator setFuel _fuelLevel;
