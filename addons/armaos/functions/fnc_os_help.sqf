/*
 * Author: Root
 * Description: Displays a list of all available commands on the computer with their descriptions.
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
 * [_computer, [], "help"] call AE3_armaos_fnc_os_help;
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

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];
private _result = [];

{
	_result pushBack format ["%1: %2", _x, _y select 1];
} forEach _availableCommands;

_result sort true;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;
