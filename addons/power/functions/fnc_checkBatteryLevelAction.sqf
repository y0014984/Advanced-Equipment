/**
 * Display battery charging level via hint.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Returns:
 * None
 * 
 */

params["_entity"];

private _result = [_entity, true] call AE3_power_fnc_getBatteryLevel;
