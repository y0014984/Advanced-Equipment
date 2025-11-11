/*
 * Author: Root
 * Description: Displays the username of the currently logged-in user. Similar to Unix whoami command.
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
 * [_computer, [], "whoami"] call AE3_armaos_fnc_os_whoami;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _unused_ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _terminal get "AE3_terminalLoginUser"] call AE3_armaos_fnc_shell_stdout;
