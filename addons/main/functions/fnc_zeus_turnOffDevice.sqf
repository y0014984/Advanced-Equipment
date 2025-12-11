/*
 * Author: Root, y0014984
 * Description: Turns off a device through the Zeus Asset Attributes Interface. Triggered by the "Turn Off" button in the Zeus interface.
 * Provides visual feedback to the Zeus curator indicating success or failure.
 *
 * Arguments:
 * None (uses BIS_fnc_initCuratorAttributes_target from mission namespace)
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_turnOffDevice;
 *
 * Public: No
 */

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _success = [_entity] call AE3_power_fnc_turnOffDevice;

    if (_success) then
    {
        ["Advanced Equipment", localize "STR_AE3_Main_Zeus_TurnedOffDevice", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, localize "STR_AE3_Main_Zeus_CantTurnOffDevice"] call BIS_fnc_showCuratorFeedbackMessage;
    };
};
