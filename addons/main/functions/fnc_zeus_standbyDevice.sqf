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
 * [] call AE3_main_fnc_zeus_standbyDevice;
 *
 */

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _success = [_entity] call AE3_power_fnc_standbyDevice;

    if (_success) then
    {
        ["Advanced Equipment", localize "STR_AE3_Main_Zeus_StandbyDevice", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, localize "STR_AE3_Main_Zeus_CantStandbyDevice"] call BIS_fnc_showCuratorFeedbackMessage;
    };
};