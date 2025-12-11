/*
 * Author: Root
 * Description: ACE3 interaction action that displays battery charge level via hint. Wrapper function that calls getBatteryLevel with hint enabled.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Battery object to check
 *
 * Return Value:
 * None
 *
 * Example:
 * [_battery] call AE3_power_fnc_checkBatteryLevelAction;
 *
 * Public: No
 */

params["_entity"];

private _result = [_entity, true] call AE3_power_fnc_getBatteryLevel;
