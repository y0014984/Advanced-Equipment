/**
 * PUBLIC
 * 
 * Sets the given device in standby mode. Works for every asset. Returns true/false depending on the success of the command.
 *
 * Arguments:
 * 0: Device <OBJECT>
 *
 * Returns:
 * 0: Result <BOOL>
 * 
 * Example:
 * private _result = [_device] call AE3_power_fnc_standbyDevice;
 *
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
