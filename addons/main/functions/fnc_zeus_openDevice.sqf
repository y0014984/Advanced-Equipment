private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _openCondition =
    (
        (_entity call (_entity getVariable ["AE3_interaction_fnc_openActionCondition", {true}])) and 
        (alive _entity) and 
        (_entity getVariable ["AE3_interaction_closeState", -1] == 1)
    );

    if (_openCondition && !((_entity getVariable ["AE3_interaction_fnc_open", {}]) isEqualTo {})) then
    {
        _entity setVariable ["AE3_power_mutex", true, true];
        
        [_entity] call (_entity getVariable "AE3_interaction_fnc_openWrapper");

        if (_entity getVariable "AE3_power_powerState" == 2) then
        {
            [_entity] call (_entity getVariable "AE3_power_fnc_turnOnWrapper");
        };

        _entity setVariable ["AE3_power_mutex", false, true];

        ["Advanced Equipment", "Device opened.", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, "Can't open device."] call BIS_fnc_showCuratorFeedbackMessage;
    };
};