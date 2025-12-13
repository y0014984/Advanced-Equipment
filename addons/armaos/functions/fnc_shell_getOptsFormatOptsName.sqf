/*
 * Author: Root, y0014984
 * Description: Formats an option name for display in help text, combining short and long forms with type information.
 *
 * Arguments:
 * 0: _shortOpt <STRING> - TODO: Add description
 * 1: _longOpt <STRING> - TODO: Add description
 * 2: _optType <STRING> - TODO: Add description
 * 3: _optSelect <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_shortOpt, _longOpt, _optType] call AE3_armaos_fnc_shell_getOptsFormatOptsName;
 *
 * Public: No
 */

params ["_shortOpt", "_longOpt", "_optType", "_optSelect"];

if ((_shortOpt isNotEqualTo "")) then { _shortOpt = "-" + _shortOpt; };
if ((_longOpt isNotEqualTo "")) then { _longOpt = "--" + _longOpt; };

private _optName = format ["%1/%2", _shortOpt, _longOpt];

if (_shortOpt isEqualTo "") then { _optName = format ["%1", _longOpt]; };
if (_longOpt isEqualTo "") then { _optName = format ["%1", _shortOpt]; };

if (_optType isEqualTo "string") then { _optName = _optName + "=<STRING>"; };
if (_optType isEqualTo "number") then { _optName = _optName + "=<NUMBER>"; };

if (_optType isEqualTo "file") then { _optName = _optName + "=<FILE>"; };
if (_optType isEqualTo "folder") then { _optName = _optName + "=<FOLDER>"; };

if (_optType isEqualTo "fileExist") then { _optName = _optName + "=<EXISTING FILE>"; };
if (_optType isEqualTo "folderExist") then { _optName = _optName + "=<EXISTING FOLDER>"; };

if (_optType isEqualTo "fileNonExist") then { _optName = _optName + "=<NON EXISTING FILE>"; };
if (_optType isEqualTo "folderNonExist") then { _optName = _optName + "=<NON EXISTING FOLDER>"; };

if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then
{
    private _optSelectString = _optSelect joinString "|";
    _optName = _optName + "=<" + _optSelectString + ">";
};

_optName;
