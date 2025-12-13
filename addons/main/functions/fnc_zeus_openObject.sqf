/*
 * Author: Root, y0014984
 * Description: Opens an object (e.g., laptop lid) through the Zeus Asset Attributes Interface. Triggered by the "Open" button.
 * Sets mutex lock during the operation, executes the open animation, and powers on the device if it was in standby.
 * Provides visual feedback to the Zeus curator.
 *
 * Arguments:
 * None (uses BIS_fnc_initCuratorAttributes_target from mission namespace)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_openObject;
 *
 * Public: No
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
