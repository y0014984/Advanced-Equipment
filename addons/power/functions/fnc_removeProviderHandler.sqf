/**
 * Removes the provider handler.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_generator"];

_genHandle = _generator getVariable 'AE3_power_generatorHandle';
[_genHandle] call CBA_fnc_removePerFrameHandler;

_generator setVariable ["AE3_power_generatorHandle", nil];

// set power state to "off" global
_generator setVariable ["AE3_power_powerState", 0, true];

// delete/reset power capacity value global
_generator setVariable ["AE3_power_powerCapacity", nil, true];
