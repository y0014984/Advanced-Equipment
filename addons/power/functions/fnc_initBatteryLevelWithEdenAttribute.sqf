/**
 * Sets the battery level for a given battery inside an entity if value is changed in Eden Editor. This will only work for an
 * entity that is placed in Eden Editor. In Zeus Mode, the variables are not set.
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

    // wait until all "init" processes are done, see: https://community.bistudio.com/wiki/Initialization_Order
    waitUntil { !isNil "BIS_fnc_init" };

    private _edenAttributePowerLevel = _entity getVariable ["AE3_EdenAttribute_PowerLevel", nil];

    // var is nil if entity is set via zeus instead of eden editor
    if (!isNil "_edenAttributePowerLevel") then
    {
        // only set power level if changed in Eden Editor; -1 is default value
        // unset is -1; regular values should be between 0 and 1
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
};