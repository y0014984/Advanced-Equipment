/*
 * Author: Root, y0014984
 * Description: Creates a search array for option parsing by combining short and long form option names.
 *
 * Arguments:
 * 0: _commandOpts <STRING> - TODO: Add description
 * 1: _formType <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_commandOpts, _formType] call AE3_armaos_fnc_shell_getOptsCreateSearchArray;
 *
 * Public: No
 */

params ["_commandOpts", "_formType"];

private _result = [];

{
    if (_formType isEqualTo "short") then { _result pushBack (_x select 1); };
    if (_formType isEqualTo "long") then { _result pushBack (_x select 2); };
} forEach _commandOpts;

_result;
