/**
 * Display generator fuel level via hint.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_entity"];

private _fuelLevel = _entity getVariable "AE3_fuelLevel";
hint format ["Fuel Level: %1 l", _fuelLevel];
