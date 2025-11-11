/*
 * Author: Root
 * Description: Copies a file from source to destination path. Similar to Unix cp command.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command options and arguments
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["/home/user/file.txt", "/tmp/file.txt"], "cp"] call AE3_armaos_fnc_os_cp;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "SOURCE", true, false],
			["path", "DEST", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

_ae3OptsThings params ["_oldPath", "_newPath"];

private _result = [];

try
{
	[_pointer, _filesystem, _oldPath, _newPath, _username, true] call AE3_filesystem_fnc_mvObj;
	_computer setVariable ["AE3_filesystem", _filesystem, 2];
	
}catch
{
	_result pushBack _exception;
};

[_computer, _result] call AE3_armaos_fnc_shell_stdout;
