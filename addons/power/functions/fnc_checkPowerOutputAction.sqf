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

private _powerCap = [_entity, true] call AE3_power_fnc_getPowerOutput;