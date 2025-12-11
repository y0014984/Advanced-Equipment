/*
 * Author: Root
 * Description: Returns the battery level of the given battery device in Wh and percent. Optionally displays a hint with the battery status. This function handles both scheduled and unscheduled execution contexts. For devices with internal batteries (like laptops), pass the internal battery object instead of the parent device.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Battery object to check
 * 1: _hint <BOOL> - (Optional, default: false) Display hint with battery level
 *
 * Return Value:
 * [Battery level in Wh, Battery level percent, Battery capacity in Wh] <ARRAY>
 *
 * Example:
 * private _batteryInfo = [_battery, true] call AE3_power_fnc_getBatteryLevel;
 * private _batteryInfo = [_laptop getVariable "AE3_power_internal", false] call AE3_power_fnc_getBatteryLevel;
 *
 * Public: Yes
 */

params ["_entity", ["_hint", false]];

/* ================================================================================ */

private _calcFnc =
{
    params ["_entity"];

    private _batteryLevel = _entity getVariable "AE3_power_batteryLevel";
    private _batteryCapacity = _entity getVariable "AE3_power_batteryCapacity";
    private _batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;

    // Wh
    _batteryLevel = _batteryLevel * 1000;
    _batteryCapacity = _batteryCapacity * 1000;

    [_batteryLevel, _batteryLevelPercent, _batteryCapacity]
};

/* ================================================================================ */

private _hintFnc =
{
    params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];

    _batteryLevel = [_batteryLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
    _batteryLevelPercent = [_batteryLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
    _batteryCapacity = [_batteryCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123

    hint format [localize "STR_AE3_Power_Interaction_BatteryLevelHint", _batteryLevel, _batteryLevelPercent, "%", _batteryCapacity];
};

/* ================================================================================ */

if (canSuspend) exitWith
{
    [_entity, "AE3_power_batteryLevel"] call AE3_main_fnc_getRemoteVar;

    private _result = [_entity] call _calcFnc;

    if (_hint) then { _result call _hintFnc; } else { _result; };
};

/* ================================================================================ */

if (!canSuspend && _hint) exitWith
{
    // Update local copy of server var
    [_entity, _hint, _calcFnc, _hintFnc] spawn
    {
        params ["_entity", "_hint", "_calcFnc", "_hintFnc"];
        
        [_entity, "AE3_power_batteryLevel"] call AE3_main_fnc_getRemoteVar; 

        private _result = [_entity] call _calcFnc;

        _result call _hintFnc;
    };
};

/* ================================================================================ */

[_entity] call _calcFnc;

/* ================================================================================ */


