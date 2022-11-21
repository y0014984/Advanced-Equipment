/**
 * Checks power output of a generator or solar panel.
 *
 * Argmuments:
 * 0: Entity <OBJECT>
 *
 * Returns:
 * None
 */

params["_entity"];

private _powerCap = [_entity] call AE3_power_fnc_getPowerOutput;

hint format [localize "STR_AE3_Power_Interaction_PowerOutputHint", _powerCap];