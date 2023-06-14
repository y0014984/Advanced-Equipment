private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _success = [_entity] call AE3_power_fnc_standbyDevice;

    if (_success) then
    {
        ["Advanced Equipment", "Device set to standby.", 5] call BIS_fnc_curatorHint;
    }
    else
    {
        [objNull, "Can't set device to standby."] call BIS_fnc_showCuratorFeedbackMessage;
    };
};