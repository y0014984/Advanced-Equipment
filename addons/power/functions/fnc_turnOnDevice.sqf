/*
 * Author: Root
 * Description: Turns on the given power device. Works for any device configured with the power system (laptops, generators, solar panels, batteries, etc.). Checks turn-on conditions including power state, mutex lock, and device-specific conditions before executing.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device to turn on
 *
 * Return Value:
 * Success status <BOOL>
 *
 * Example:
 * private _success = [_laptop] call AE3_power_fnc_turnOnDevice;
 * private _success = [_generator] call AE3_power_fnc_turnOnDevice;
 *
 * Public: Yes
 */

params ["_device"];

private _result = false;

private _turnOnCondition =
(
    (_device call (_device getVariable ["AE3_power_fnc_turnOnCondition", {true}]) and
    (alive _device) and 
    (_device getVariable ["AE3_power_powerState", -1] != 1) and 
    !(_device getVariable ["AE3_power_mutex", false]) and 
    (_device getVariable ["AE3_interaction_closeState", 0] == 0))
);

if (_turnOnCondition && ((_device getVariable ["AE3_power_fnc_turnOn", {}]) isNotEqualTo {})) then
{
    _device setVariable ["AE3_power_mutex", true, true];

    [_device] call (_device getVariable "AE3_power_fnc_turnOnWrapper");

    _device setVariable ["AE3_power_mutex", false, true];

    _result = true;
};

_result;
