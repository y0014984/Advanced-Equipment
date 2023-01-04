/**
 * Sets the battery level for a given battery inside an entity if value is changed in Eden Editor.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 1: Entity <OBJECT>
 * 
 * Returns:
 * None
 */

params ["_battery", "_entity"];

[_battery, _entity] spawn
{
    params ["_battery", "_entity"];

    // wait until the eden attribute is set via expression; unset is -1; regular values should be between 0 and 1
    waitUntil { !(isNil {_entity getVariable "AE3_EdenAttribute_PowerLevel"}) };

    private _edenAttributePowerLevel = _entity getVariable "AE3_EdenAttribute_PowerLevel";

    // only set power level if changed in Eden Editor; -1 is default value
    if (_edenAttributePowerLevel != -1) then
    {
        // apply min and max values
        if (_edenAttributePowerLevel < 0) then { _edenAttributePowerLevel = 0; };
        if (_edenAttributePowerLevel > 1) then { _edenAttributePowerLevel = 1; };

        // calculate real battery level by multiplying relative value with max capacity
        private _batteryLevel = _edenAttributePowerLevel;
        private _batteryCapacity = _battery getVariable "AE3_power_batteryCapacity";
        _batteryLevel = _batteryCapacity * _batteryLevel;

        // set battery level
        _battery setVariable ["AE3_power_batteryLevel", _batteryLevel, true];
    };
};