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

params ["_battery"];

private _params = [_battery] call AE3_power_fnc_getBatteryLevel;

_params params ["_batteryLevel", "_batteryLevelPercent"];

hint format ["Battery Level: %1 Wh (%2%3)", _batteryLevel, _batteryLevelPercent, "%"];
