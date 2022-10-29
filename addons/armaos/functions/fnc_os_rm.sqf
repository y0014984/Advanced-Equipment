/**
 * Removes/deletes a given file on a given computer. Returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options > 1) exitWith { [_computer, "'rm' has too many options"] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [_computer, "'rm' has too few options"] call AE3_armaos_fnc_shell_stdout; };

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _obj = _options select 0;
private _result = [];
_result = [_obj];

try
{
	[_pointer, _filesystem, _obj, _username] call AE3_filesystem_fnc_delObj;
	_computer setVariable ['AE3_filesystem', _filesystem];
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};