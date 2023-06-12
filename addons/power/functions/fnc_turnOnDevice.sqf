params ["_entity"];

private _result = false;

private _turnOnCondition =
(
    (_entity call (_entity getVariable ["AE3_power_fnc_turnOnCondition", {true}]) and
    (alive _entity) and 
    (_entity getVariable ["AE3_power_powerState", -1] != 1) and 
    !(_entity getVariable ["AE3_power_mutex", false]) and 
    (_entity getVariable ["AE3_interaction_closeState", 0] == 0))
);

if (_turnOnCondition && !((_entity getVariable ["AE3_power_fnc_turnOn", {}]) isEqualTo {})) then
{
    _entity setVariable ["AE3_power_mutex", true, true];

    [_entity] call (_entity getVariable "AE3_power_fnc_turnOnWrapper");

    _entity setVariable ["AE3_power_mutex", false, true];

    _result = true;
};

_result;