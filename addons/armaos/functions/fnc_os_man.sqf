/**
 * Prints/outputs informatioms about a given shell command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
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