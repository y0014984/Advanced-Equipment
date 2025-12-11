/*
 * Author: Root, y0014984
 * Description: Returns the current fuel level of a generator in absolute liters and as a percentage of capacity. Uses Arma 3's fuel command to get current level.
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
private _fuelLevelPercent = fuel _entity;

private _fuelLevel = _fuelCapacity * _fuelLevelPercent;

_fuelLevelPercent = _fuelLevelPercent * 100;

[_fuelLevel, _fuelLevelPercent, _fuelCapacity]
