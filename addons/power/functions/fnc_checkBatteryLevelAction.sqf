/**
 * Display battery charging level via hint.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_entity"];

private _class = typeOf _entity;

private _batteryLevel = _entity getVariable "AE3_power_batteryLevel";
private _batteryCapacity = _entity getVariable "AE3_power_batteryCapacity";
private _batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;
hint format ["Battery Level: %1 Wh (%2%3)", _batteryLevel  * 1000, _batteryLevelPercent, "%"];
