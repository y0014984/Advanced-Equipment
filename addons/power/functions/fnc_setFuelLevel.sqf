// File: fnc_setFuelLevel.sqf
/*
 * Author: Root, y0014984
 * Description: Sets the fuel level of a generator to a specified percentage. The value is automatically clamped between 0 and 100 percent. Writes the generator's ACE refuel cargo store, which a generator has in place of the engine fuel tank a prop cannot carry.
 *
 * Arguments:
 * 0: _generator <OBJECT> - Generator object to modify
 * 1: _fuelLevelPercent <NUMBER> - Fuel level in percent (0-100)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator, 100] call AE3_power_fnc_setFuelLevel;
 * [_generator, 50] call AE3_power_fnc_setFuelLevel;
 *
 * Public: Yes
 */

params ["_generator", "_fuelLevelPercent"];

_fuelLevelPercent = ((_fuelLevelPercent min 100) max 0); // normalize; max = 100 and min = 0

private _fuelCapacity = _generator getVariable ["AE3_power_fuelCapacity", 0];

[_generator, _fuelCapacity * (_fuelLevelPercent / 100)] call ace_refuel_fnc_setFuel;
