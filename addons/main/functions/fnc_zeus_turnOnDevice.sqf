private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

[_entity] spawn
{
    params ["_entity"];

    private _success = [_entity] call AE3_power_fnc_turnOnDevice;

    if (_success) then
    {
        hint "Device turned on.";
    }
    else
    {
        hint "Can't turn on device.";
    };
};