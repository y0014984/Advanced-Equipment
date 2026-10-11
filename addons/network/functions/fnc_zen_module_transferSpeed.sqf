// File: fnc_zen_module_transferSpeed.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: ZEN dialog for the curator-placed "Network Speed" module: asks for the speed (KB/s) and
 * optional user accounts, then applies them to the targeted routers/computers on the server.
 *
 * Arguments:
 * 0: _moduleNetId <STRING> - netId of the module
 * 1: _netIds <ARRAY> - netIds of the targeted devices
 *
 * Return Value:
 * None
 *
 * Example:
 * [_moduleNetId, _netIds] call AE3_network_fnc_zen_module_transferSpeed;
 *
 * Public: No
 */

params ["_moduleNetId", "_netIds"];

private _first = objectFromNetId (_netIds param [0, ""]);
private _current = _first getVariable ["AE3_network_transferSpeed", 0];

private _onConfirm = {
    params ["_values", "_args"];
    _values params ["_speedText", "_usersText"];
    _args params ["_moduleNetId", "_netIds"];

    private _speed = round (parseNumber _speedText);
    private _users = (_usersText splitString ", ") select { _x isNotEqualTo "" };
    if (_users isEqualTo []) then { _users = [""]; };

    {
        private _device = objectFromNetId _x;
        { [_device, _speed, _x] call AE3_network_fnc_setTransferSpeed; } forEach _users;
    } forEach _netIds;

    [localize "STR_AE3_Network_Config_TransferSpeedDisplayName", format [localize "STR_AE3_Network_TransferSpeed_Applied", [str _speed + " KB/s", localize "STR_AE3_Network_TransferSpeed_Default"] select (_speed <= 0), count _netIds], 5] call BIS_fnc_curatorHint;
    (objectFromNetId _moduleNetId) remoteExec ["deleteVehicle", 2];
};

private _onCancel = {
    params ["_values", "_args"];
    (objectFromNetId (_args select 0)) remoteExec ["deleteVehicle", 2];
};

[
    "STR_AE3_Network_Config_TransferSpeedDisplayName",
    [
        ["EDIT", [localize "STR_AE3_Network_TransferSpeed_Speed", localize "STR_AE3_Network_TransferSpeed_SpeedTooltip"], [str _current]],
        ["EDIT", [localize "STR_AE3_Network_TransferSpeed_Users", localize "STR_AE3_Network_TransferSpeed_UsersTooltip"], [""]]
    ],
    _onConfirm,
    _onCancel,
    [_moduleNetId, _netIds]
] call EFUNC(main,zen_createDialog);
