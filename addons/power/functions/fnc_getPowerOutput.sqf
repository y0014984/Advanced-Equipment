/**
 * Returns device power output.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * 0: Power Output <STRING>
 */

params["_entity"];

// Update local copy of server var
[_entity] spawn { params ["_entity"]; [_entity, "AE3_power_powerCapacity"] call AE3_main_fnc_getRemoteVar; };

private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];

// Watts
_powerCap = _powerCap * 3600 * 1000;

_powerCap;
