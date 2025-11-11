/*
 * Author: Root
 * Description: Creates an empty file with the given name in the current directory. Similar to Unix touch command.
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
 * [_computer, ["newfile.txt"], "touch"] call AE3_armaos_fnc_os_touch;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["filename", "FILENAME", true, false]
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

private _filename = _ae3OptsThings select 0;

try
{
	[
		_pointer,
		_filesystem,
		_filename,
		"",
		_username,
		_username
	] call AE3_filesystem_fnc_createFile;

	_computer setVariable ["AE3_filesystem", _filesystem, 2];
}
catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
