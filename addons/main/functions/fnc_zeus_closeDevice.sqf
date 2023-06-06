private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _closeCondition =
    (
        (_entity call (_entity getVariable ["AE3_interaction_fnc_closeActionCondition", {true}])) and 
        (alive _entity) and 
        (_entity getVariable ["AE3_interaction_closeState", -1] == 0)
    );

    if (_closeCondition && !((_entity getVariable ["AE3_interaction_fnc_close", {}]) isEqualTo {})) then
    {
        _entity setVariable ["AE3_power_mutex", true, true];
        
        [_entity] call (_entity getVariable "AE3_interaction_fnc_closeWrapper");

        if (_entity getVariable "AE3_power_powerState" == 1) then
        {
            [_entity] call (_entity getVariable "AE3_power_fnc_standbyWrapper");
        };

        _entity setVariable ["AE3_power_mutex", false, true];

        hint "Device closed.";
    }
    else
    {
        hint "Can't close device.";
    };
};