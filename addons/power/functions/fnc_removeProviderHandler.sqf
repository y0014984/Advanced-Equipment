/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Removes the per-frame handler from a power provider, stopping its power generation loop. Resets power state to off and clears power capacity. Called when generators, batteries, or solar panels are turned off.
 *
 * Arguments:
 * 0: _generator <OBJECT> - Power provider object to stop
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] call AE3_power_fnc_removeProviderHandler;
 * [_solarPanel] remoteExecCall ["AE3_power_fnc_removeProviderHandler", 2];
 *
 * Public: No
 */

params ["_generator"];

_genHandle = _generator getVariable 'AE3_power_generatorHandle';
[_genHandle] call CBA_fnc_removePerFrameHandler;

_generator setVariable ["AE3_power_generatorHandle", nil];

// set power state to "off" global
_generator setVariable ["AE3_power_powerState", 0, true];

// delete/reset power capacity value global
_generator setVariable ["AE3_power_powerCapacity", nil, true];
