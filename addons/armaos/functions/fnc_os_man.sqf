/*
 * Author: Root
 * Description: Displays the manual/help information for a specific command. Similar to Unix man command.
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
 * [_computer, ["ls"], "man"] call AE3_armaos_fnc_os_man;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "COMMAND", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];

private _result = [];

private _command = _ae3OptsThings select 0;

if(_command in _availableCommands) then
{
	_result = (_availableCommands get _command) select 2;
}else
{
	_result = format [localize "STR_AE3_ArmaOS_Exception_CommandNotFound", _command];
};

[_computer, _result] call AE3_armaos_fnc_shell_stdout;
