/*
 * Author: Root
 * Description: Changes the current working directory of the terminal. Similar to Unix cd command.
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
 * [_computer, ["/home/user"], "cd"] call AE3_armaos_fnc_os_cd;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "DIRECTORY", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _ae3OptsThings = _ae3OptsThings joinString " ";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	private _result = [_computer getVariable ["AE3_filepointer", []], 
				_computer getVariable ["AE3_filesystem", createHashMap], 
				_ae3OptsThings,
				_username] call AE3_filesystem_fnc_chdir;

	[(_result select 1), _username, 0] call AE3_filesystem_fnc_hasPermission;
	_computer setVariable ["AE3_filepointer", _result select 0];

}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
