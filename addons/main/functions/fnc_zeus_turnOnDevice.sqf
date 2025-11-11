/*
 * Author: Root
 * Description: Turns on a device through the Zeus Asset Attributes Interface. Triggered by the "Turn On" button in the Zeus interface.
 * Provides visual feedback to the Zeus curator indicating success or failure.
 *
 * Arguments:
 * None (uses BIS_fnc_initCuratorAttributes_target from mission namespace)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_turnOnDevice;
 *
 * Public: No
 */

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _success = [_entity] call AE3_power_fnc_turnOnDevice;

    if (_success) then
    {
        ["Advanced Equipment", localize "STR_AE3_Main_Zeus_TurnedOnDevice", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, localize "STR_AE3_Main_Zeus_CantTurnOnDevice"] call BIS_fnc_showCuratorFeedbackMessage;
    };
};
