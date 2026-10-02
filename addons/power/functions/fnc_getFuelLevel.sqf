// File: fnc_getFuelLevel.sqf
/*
 * Author: Root, y0014984
 * Description: Returns the current fuel level of a generator in absolute liters and as a percentage of capacity. The level is held in the generator's ACE refuel cargo store, which a generator has in place of the engine fuel tank a prop cannot carry, and which a connected nozzle fills directly.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object
 *
 * Return Value:
 * [Fuel level in liters, Fuel level percent (0-100), Fuel capacity in liters] <ARRAY>
 *
 * Example:
 * private _fuelInfo = [_generator] call AE3_power_fnc_getFuelLevel;
 * _fuelInfo params ["_liters", "_percent", "_capacity"];
 *
 * Public: Yes
 */

params ["_entity"];

private _fuelCapacity = _entity getVariable "AE3_power_fuelCapacity";
private _fuelLevel = [_entity] call ace_refuel_fnc_getFuel;

private _fuelLevelPercent = if (_fuelCapacity > 0) then { (_fuelLevel / _fuelCapacity) * 100 } else { 0 };

[_fuelLevel, _fuelLevelPercent, _fuelCapacity]
