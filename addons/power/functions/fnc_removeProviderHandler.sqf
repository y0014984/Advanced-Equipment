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

_generator setVariable ["AE3_powerState", 0, true];

_genHandle = _generator getVariable 'AE3_generatorHandle';
[_genHandle] call CBA_fnc_removePerFrameHandler;

_generator setVariable ['AE3_generatorHandle', nil, true];