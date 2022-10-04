/**
 * Moves/renames a given file on a given computer.
 * Returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

if (count _options > 2) exitWith {[_computer, "Too many options"] call AE3_armaos_fnc_shell_stdout;};

if (count _options < 2) exitWith {[_computer, "Too few options"] call AE3_armaos_fnc_shell_stdout;};

_options params ['_oldPath', '_newPath'];

private _result = [];

try
{
	[_pointer, _filesystem, _oldPath, _newPath, _username] call AE3_filesystem_fnc_mvObj;
	_computer setVariable ['AE3_filesystem', _filesystem, true];
	
}catch
{
	_result pushBack _exception;
};
[_computer, _result] call AE3_armaos_fnc_shell_stdout;
