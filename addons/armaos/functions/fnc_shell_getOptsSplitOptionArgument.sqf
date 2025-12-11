/*
 * Author: Root, y0014984
 * Description: Splits an option-argument pair (e.g., '--key=value' into ['--key', 'value']).
 *
 * Arguments:
 * 0: _opt <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_opt] call AE3_armaos_fnc_shell_getOptsSplitOptionArgument;
 *
 * Public: No
 */

params ["_opt"];

// split into option and argument, if existing
private _optSegments = _opt splitString "=";
private _optWithoutArg = _optSegments select 0;
private _arg = "";
if ((count _optSegments) >= 2) then { _arg = _optSegments select 1; };

[_optWithoutArg, _arg];
