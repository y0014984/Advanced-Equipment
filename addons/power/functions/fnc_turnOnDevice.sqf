/**
 * PUBLIC
 * 
 * Turns on the given device. Works for every asset. Returns true/false depending on the success of the command.
 *
 * Arguments:
 * 0: Device <OBJECT>
 *
 * Returns:
 * 0: Result <BOOL>
 * 
 * Example:
 * private _result = [_device] call AE3_power_fnc_turnOnDevice;
 *
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

if (_turnOnCondition && !((_device getVariable ["AE3_power_fnc_turnOn", {}]) isEqualTo {})) then
{
    _device setVariable ["AE3_power_mutex", true, true];

    [_device] call (_device getVariable "AE3_power_fnc_turnOnWrapper");

    _device setVariable ["AE3_power_mutex", false, true];

    _result = true;
};

_result;