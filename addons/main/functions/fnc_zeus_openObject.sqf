/**
 * PRIVATE
 *
 * This function is triggered by a button in the default AE3 Zeus Asset Attributes Interface.
 * The mechanism is similar to the code that allows this action in the ACE3 Interaction of the object.
 *
 * Arguments:
 * None
 *
 * Results:
 * Visual Feedback in Zeus Interface
 *
 * Example:
 * [] call AE3_main_fnc_zeus_openObject;
 *
 */

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

    if (_openCondition && ((_entity getVariable ["AE3_interaction_fnc_open", {}]) isNotEqualTo {})) then
    {
        _entity setVariable ["AE3_power_mutex", true, true];
        
        [_entity] call (_entity getVariable "AE3_interaction_fnc_openWrapper");

        if (_entity getVariable "AE3_power_powerState" == 2) then
        {
            [_entity] call (_entity getVariable "AE3_power_fnc_turnOnWrapper");
        };

        _entity setVariable ["AE3_power_mutex", false, true];

        ["Advanced Equipment", localize "STR_AE3_Main_Zeus_ObjectOpened", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, localize "STR_AE3_Main_Zeus_CantOpenObject"] call BIS_fnc_showCuratorFeedbackMessage;
    };
};
