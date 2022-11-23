/**
 * Returns the battery level of the given device. Optional displays hint.
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

// Update local copy of server var
[_entity, _hint] spawn
{
    params ["_entity", "_hint"];
    
    [_entity, "AE3_power_batteryLevel"] call AE3_main_fnc_getRemoteVar; 

    if (_hint) then
    {
        private _batteryLevel = _entity getVariable "AE3_power_batteryLevel";
        private _batteryCapacity = _entity getVariable "AE3_power_batteryCapacity";
        private _batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;

        // Wh
        _batteryLevel = _batteryLevel * 1000;
        _batteryCapacity = _batteryCapacity * 1000;

        _batteryLevel = [_batteryLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
        _batteryLevelPercent = [_batteryLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
        _batteryCapacity = [_batteryCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123

        hint format [localize "STR_AE3_Power_Interaction_BatteryLevelHint", _batteryLevel, _batteryLevelPercent, "%", _batteryCapacity];
    };
};

private _batteryLevel = _entity getVariable "AE3_power_batteryLevel";
private _batteryCapacity = _entity getVariable "AE3_power_batteryCapacity";
private _batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;

// Wh
_batteryLevel = _batteryLevel * 1000;
_batteryCapacity = _batteryCapacity * 1000;

[_batteryLevel, _batteryLevelPercent, _batteryCapacity]
