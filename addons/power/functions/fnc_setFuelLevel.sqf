/**
 * Sets the fuel level of a given generator.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 0: Fuel Level Percent <NUMBER>
 * 
 */

params ["_generator", "_fuelLevelPercent"];

private _fuelCapacity = _generator getVariable "AE3_power_batteryCapacity";
private _fuelLevel = _fuelLevelPercent / 100;

_generator setFuel _fuelLevel;