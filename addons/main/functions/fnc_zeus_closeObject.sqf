/*
 * Author: Root
 * Description: Closes an object (e.g., laptop lid) through the Zeus Asset Attributes Interface. Triggered by the "Close" button.
 * Sets mutex lock during the operation, executes the close animation, and puts the device into standby if it was on.
 * Provides visual feedback to the Zeus curator.
 *
 * Arguments:
 * None (uses BIS_fnc_initCuratorAttributes_target from mission namespace)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_closeObject;
 *
 * Public: No
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

    if (_closeCondition && ((_entity getVariable ["AE3_interaction_fnc_close", {}]) isNotEqualTo {})) then
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
