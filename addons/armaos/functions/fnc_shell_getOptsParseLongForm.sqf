/*
 * Author: Root, y0014984
 * Description: Parses long-form command options (--option=value format) and returns parsed option values.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _longOpt <STRING> - TODO: Add description
 * 2: _commandOpts <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _longOpt, _commandOpts] call AE3_armaos_fnc_shell_getOptsParseLongForm;
 *
 * Public: No
 */

params ["_computer", "_longOpt", "_commandOpts"];

private _result = createHashMap;

// remove the leading "--"
_longOpt = _longOpt select [2, (count _longOpt) - 2];

// split into option and argument, if existing
([_longOpt] call AE3_armaos_fnc_shell_getOptsSplitOptionArgument) params ["_longOptWithoutArg", "_arg"];

private _searchArray = [_commandOpts, "long"] call AE3_armaos_fnc_shell_getOptsCreateSearchArray;
private _searchIndex = _searchArray find _longOptWithoutArg;

if (_searchIndex != -1) then
{
    private _longOptSettings = _commandOpts select _searchIndex;

    _result set ([_computer, _longOptSettings, _arg] call AE3_armaos_fnc_shell_getOptsConvertArgType);
};

_result;
