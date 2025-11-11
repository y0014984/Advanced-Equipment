/*
 * Author: Root
 * Description: Displays the specified text to the terminal output. Supports -e flag for backslash interpretation. Similar to Unix echo command.
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
 * [_computer, ["Hello World"], "echo"] call AE3_armaos_fnc_os_echo;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts =
[
    ["_backslashInterpretion", "e", "", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Echo_backslash"]
];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
            ["path", "TEXT", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
private _backslashInterpretion = false;
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _text = _ae3OptsThings joinString " ";

if (_backslashInterpretion) then
{
	_text = [_text, "\n", true] call BIS_fnc_splitString;
};

[_computer, _text] call AE3_armaos_fnc_shell_stdout;
