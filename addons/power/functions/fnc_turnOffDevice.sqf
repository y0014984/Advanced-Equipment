params ["_entity"];

private _result = false;

private _turnOffCondition =
(
    (_entity call (_entity getVariable ["AE3_power_fnc_turnOffCondition", {true}]) and
    (alive _entity) and 
    (_entity getVariable ["AE3_power_powerState", -1] != 0) and 
    !(_entity getVariable ["AE3_power_mutex", false]) and 
    (_entity getVariable ["AE3_interaction_closeState", 0] == 0))
);

if (_turnOffCondition && !((_entity getVariable ["AE3_power_fnc_turnOff", {}]) isEqualTo {})) then
{
    _entity setVariable ["AE3_power_mutex", true, true];

    [_entity] call (_entity getVariable "AE3_power_fnc_turnOffWrapper");

    _entity setVariable ["AE3_power_mutex", false, true];

    _result = true;
};

_result;