/*
 * Author: Root, y0014984
 * Description: Converts a command argument string to the specified type (number, string, bool, etc.).
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _optSettings <STRING> - TODO: Add description
 * 2: _arg <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _optSettings, _arg] call AE3_armaos_fnc_shell_getOptsConvertArgType;
 *
 * Public: No
 */

params ["_computer", "_optSettings", "_arg"];

private _optVarName = _optSettings select 0;
private _optType = _optSettings select 3;
private _optSelect = [];
private _fsObjExists = false;

if (_optType isEqualTo "bool") exitWith { [_optVarName, true]; };

if ((_optType isEqualTo "string") && (_arg isNotEqualTo "")) exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "number") && (_arg isNotEqualTo "")) exitWith { [_optVarName, parseNumber _arg]; };

if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then { _optSelect = _optSettings select 7; };

if ((_optType isEqualTo "stringSelect") && (_arg isNotEqualTo "") && (_arg in _optSelect)) exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "numberSelect") && (_arg isNotEqualTo "") && ((parseNumber _arg) in _optSelect)) exitWith { [_optVarName, parseNumber _arg]; };

if ((_optType isEqualTo "file") && (_arg isNotEqualTo "")) exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "folder") && (_arg isNotEqualTo "")) exitWith { [_optVarName, _arg]; };

if (((_optType isEqualTo "fileExist") || (_optType isEqualTo "folderExist") || (_optType isEqualTo "fileNonExist") || (_optType isEqualTo "folderNonExist")) && (_arg isNotEqualTo "")) then
{
    // if _arg was set via multi bool option, like ls -alh, _arg is set to true instead of ""
    if ((typeName _arg) isNotEqualTo "BOOL") then
    {
        private _pointer = _computer getVariable "AE3_filepointer";
        private _filesystem = _computer getVariable "AE3_filesystem";
        private _terminal = _computer getVariable "AE3_terminal";
        private _username = _terminal get "AE3_terminalLoginUser";

        _fsObjExists = [_pointer, _filesystem, _arg, _username] call AE3_filesystem_fnc_fsObjExists;
    };
};

if ((_optType isEqualTo "fileExist") && (_fsObjExists) && (typeName _arg) isNotEqualTo "BOOL") exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "folderExist") && (_fsObjExists) && (typeName _arg) isNotEqualTo "BOOL") exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "fileNonExist") && (!_fsObjExists) && (typeName _arg) isNotEqualTo "BOOL") exitWith { [_optVarName, _arg]; };

if ((_optType isEqualTo "folderNonExist") && (!_fsObjExists) && (typeName _arg) isNotEqualTo "BOOL") exitWith { [_optVarName, _arg]; };
