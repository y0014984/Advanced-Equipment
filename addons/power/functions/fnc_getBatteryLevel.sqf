/**
 * Returns the battery level of the given device. Optional displays hint.
 * This function will check if it's executed in scheduled or unscheduled mode.
 * if executed in unscheduled mode, the result could be outdated.
 * The given entity must be a battery. If you want to check an entity with an internal
 * battery, like the laptop, you need to pass the object of the internal battery
 * to this function instead of laptop itself.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Hint <BOOLEAN> (Optional)
 * 
 * Returns:
 * 0: Battery Level absolute <NUMBER>
 * 1: Battery Level percent <NUMBER>
 * 2: Battery Capacity <NUMBER>
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


