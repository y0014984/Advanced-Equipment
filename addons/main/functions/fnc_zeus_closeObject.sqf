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
 * [] call AE3_main_fnc_zeus_closeObject;
 *
 */

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

        ["Advanced Equipment", localize "STR_AE3_Main_Zeus_ObjectClosed", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, localize "STR_AE3_Main_Zeus_CantCloseObject"] call BIS_fnc_showCuratorFeedbackMessage;
    };
};