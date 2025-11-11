/*
 * Author: Root
 * Description: Lists files and directories in the specified directory. Supports -l flag for detailed listing. Similar to Unix ls command.
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
 * [_computer, ["-l", "/home"], "ls"] call AE3_armaos_fnc_os_ls;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = 
	[
		["_long", "l", "long", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Ls_long"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "DIRECTORIES", false, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _path = _ae3OptsThings;

if (_path isEqualTo []) then
{
	_path = [""];
};

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

private _output = [];

try
{
	{
		private _dir = [_pointer, _filesystem, _x, _username, _long] call AE3_filesystem_fnc_lsdir;
		_output append _dir;
	}forEach _path;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};

[_computer, _output] call AE3_armaos_fnc_shell_stdout;
