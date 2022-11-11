/**
 * Display device power state via hint.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_target"];

private _powerState = [_target] call AE3_power_fnc_getPowerState;

hint format ["Power State: %1", _powerState];