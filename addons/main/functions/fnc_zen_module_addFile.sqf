// File: fnc_zen_module_addFile.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Zeus Enhanced dialog variant of the Add File module. Opens a ZEN Dynamic Dialog on the
 * curator's machine and, on confirm, funnels the input into the same server device-op the legacy
 * curator dialog uses (ae3_main_zeusDeviceOp -> "addFile"). Owns the module lifecycle.
 *
 * Arguments:
 * 0: _module <OBJECT> - The module logic
 * 1: _computer <OBJECT> - The target computer
 *
 * Return Value:
 * None
 *
 * Example:
 * [_module, _computer] call AE3_main_fnc_zen_module_addFile;
 *
 * Public: No
 */

params ["_module", "_computer"];

private _onConfirm = {
    params ["_values", "_args"];
    _values params ["_path", "_content", "_isCode", "_owner", "_oRead", "_oWrite", "_oExec", "_eRead", "_eWrite", "_eExec", "_enableEncryption", "_encryptionAlgorithm", "_encryptionKey"];
    _args params ["_module", "_computer"];

    private _permissions = [[_oRead, _oWrite, _oExec], [_eRead, _eWrite, _eExec]];

    if (_path isEqualTo "") exitWith {
        [objNull, localize "STR_AE3_Main_Zeus_PathMissing"] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _module;
    };
    if (_owner isEqualTo "") exitWith {
        [objNull, localize "STR_AE3_Main_Zeus_OwnerMissing"] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _module;
    };
    if (_enableEncryption && _encryptionKey isEqualTo "") exitWith {
        [objNull, localize "STR_AE3_Main_Zeus_KeyMissing"] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _module;
    };
    if ((_path find " ") != -1) exitWith {
        [objNull, localize "STR_AE3_Main_Zeus_PathContainsSpaces"] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _module;
    };
    if ((_owner find " ") != -1) exitWith {
        [objNull, localize "STR_AE3_Main_Zeus_OwnerContainsSpaces"] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _module;
    };

    ["ae3_main_zeusDeviceOp", [netId _computer, "addFile", [_path, _content, _isCode, _owner, _permissions, _enableEncryption, _encryptionAlgorithm, _encryptionKey], clientOwner]] call CBA_fnc_serverEvent;
    deleteVehicle _module;
};

private _onCancel = {
    params ["_values", "_args"];
    deleteVehicle (_args select 0);
};

private _algorithms = missionNamespace getVariable ["AE3_filesystem_encryptionAlgorithms", [["caesar", "Caesar", true], ["columnar", "Columnar", true]]];
private _algorithmIds = _algorithms apply {_x select 0};
private _algorithmLabels = _algorithms apply {_x select 1};

[
    "STR_AE3_Filesystem_Config_AddFileDisplayName",
    [
        ["EDIT", "Path", [""]],
        ["EDIT:MULTI", "Content", [""]],
        ["CHECKBOX", "Is executable code", false],
        ["EDIT", "Owner", ["root"]],
        ["CHECKBOX", "Owner: Read", true],
        ["CHECKBOX", "Owner: Write", true],
        ["CHECKBOX", "Owner: Execute", false],
        ["CHECKBOX", "Everyone: Read", true],
        ["CHECKBOX", "Everyone: Write", false],
        ["CHECKBOX", "Everyone: Execute", false],
        ["CHECKBOX", "Enable encryption", false],
        ["COMBO", "Encryption algorithm", [_algorithmIds, _algorithmLabels, 0]],
        ["EDIT", "Encryption key", [""]]
    ],
    _onConfirm,
    _onCancel,
    [_module, _computer]
] call FUNC(zen_createDialog);
