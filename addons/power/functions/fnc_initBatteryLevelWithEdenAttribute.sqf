/*
 * Author: Root, y0014984
 * Description: Applies Eden Editor battery level attribute to a battery after mission initialization. Only works for entities placed in Eden Editor (not Zeus). Waits for BIS_fnc_init to complete before reading and applying the AE3_EdenAttribute_PowerLevel attribute. Value is normalized to 0-1 range.
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object to set
 * 1: _entity <OBJECT> - Parent entity with Eden attribute
 *
 * Return Value:
 * None
 *
 * Example:
 * [_battery, _laptop] call AE3_power_fnc_initBatteryLevelWithEdenAttribute;
 *
 * Public: No
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
