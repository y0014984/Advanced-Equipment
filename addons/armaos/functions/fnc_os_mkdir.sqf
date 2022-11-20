/**
 * Creates a given folder/directory on a given computer. Returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * None
 */

// TODO: add parameter for recursive folder creation; add parameter for setting permissions

params ["_computer", "_options"];

private _commandName = "mkdir";

if (count _options > 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooManyOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooFewOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _obj = _options select 0;
private _result = [];
_result = [_obj];

try
{
	[
		_pointer,
		_filesystem,
		_obj,
		_username,
		_username
	] call AE3_filesystem_fnc_createDir;

	_computer setVariable ["AE3_filesystem", _filesystem, 2];
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};