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

hint format [localize "STR_AE3_Power_Interaction_PowerStateHint", _powerState];