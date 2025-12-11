/*
 * Author: Root, y0014984
 * Description: ACE3 interaction action that displays power output via hint. Wrapper function that calls getPowerOutput with hint enabled.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator or solar panel object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] call AE3_power_fnc_checkPowerOutputAction;
 *
 * Public: No
 */

params["_entity"];

private _powerCap = [_entity, true] call AE3_power_fnc_getPowerOutput;
