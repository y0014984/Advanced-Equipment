/**
 * Searches for a specific file in the current folder. Outputs results to stadout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Search String <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options > 1) exitWith { [_computer, "'find' has too many options"] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [_computer, "'find' has too few options"] call AE3_armaos_fnc_shell_stdout; };

private _searchString = _options select 0;

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;

private _terminal = _computer getVariable "AE3_terminal";
private _user = _terminal get "AE3_terminalLoginUser";

private _result = [_pointer, _current, _user, _searchString] call AE3_filesystem_fnc_findFileByName;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;