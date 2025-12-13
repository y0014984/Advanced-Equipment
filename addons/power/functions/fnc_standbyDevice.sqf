/*
 * Author: Root, y0014984
 * Description: Sets the given device to standby mode with reduced power consumption. Works for any device configured with standby support (primarily laptops). Checks standby conditions including current power state, mutex lock, and device-specific conditions before executing.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device to put in standby
 *
 * Return Value:
 * Success status <BOOL>
 *
 * Example:
 * private _success = [_laptop] call AE3_power_fnc_standbyDevice;
 *
 * Public: Yes
 */

params ["_device"];

private _result = false;

private _standbyCondition =
(
    (_device call (_device getVariable ["AE3_power_fnc_standbyCondition", {true}]) and
    (alive _device) and 
    (_device getVariable ["AE3_power_powerState", -1] == 1) and 
    !(_device getVariable ["AE3_power_mutex", false]) and 
    (_device getVariable ["AE3_interaction_closeState", 0] == 0))
);

if (_standbyCondition && ((_device getVariable ["AE3_power_fnc_standby", {}]) isNotEqualTo {})) then
{
    _device setVariable ["AE3_power_mutex", true, true];

    [_device] call (_device getVariable "AE3_power_fnc_standbyWrapper");

    _device setVariable ["AE3_power_mutex", false, true];

    _result = true;
};

_result;
