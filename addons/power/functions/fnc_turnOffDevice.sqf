/*
 * Author: Root, y0014984
 * Description: Turns off the given power device. Works for any device configured with the power system (laptops, generators, solar panels, batteries, etc.). Checks turn-off conditions including power state, mutex lock, and device-specific conditions before executing.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device to turn off
 *
 * Return Value:
 * Success status <BOOL>
 *
 * Example:
 * private _success = [_laptop] call AE3_power_fnc_turnOffDevice;
 * private _success = [_generator] call AE3_power_fnc_turnOffDevice;
 *
 * Public: Yes
 */

params ["_device"];

private _result = false;

private _turnOffCondition =
(
    (_device call (_device getVariable ["AE3_power_fnc_turnOffCondition", {true}]) and
    (alive _device) and 
    (_device getVariable ["AE3_power_powerState", -1] != 0) and 
    !(_device getVariable ["AE3_power_mutex", false]) and 
    (_device getVariable ["AE3_interaction_closeState", 0] == 0))
);

if (_turnOffCondition && ((_device getVariable ["AE3_power_fnc_turnOff", {}]) isNotEqualTo {})) then
{
    _device setVariable ["AE3_power_mutex", true, true];

    [_device] call (_device getVariable "AE3_power_fnc_turnOffWrapper");

    _device setVariable ["AE3_power_mutex", false, true];

    _result = true;
};

_result;
