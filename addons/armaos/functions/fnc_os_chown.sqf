/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Changes the owner of a file or directory. Supports -r flag for recursive operation. Similar to Unix chown command.
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
 * [_computer, ["/home/user/file.txt", "newowner"], "chown"] call AE3_armaos_fnc_os_chown;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [
	["_recursive", "r", "recursive", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Chown_recursive"]
];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "PATH", true, false],
			["path", "OWNER", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};
_ae3OptsThings params ["_path", '_owner'];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	[_pointer, _filesystem, _path, _username, _owner, _recursive] call AE3_filesystem_fnc_chown;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
