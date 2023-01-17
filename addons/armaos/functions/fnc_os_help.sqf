/**
 * Prints/outputs the available armaOS terminal commands to stdout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
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
			["command", _commandName, true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];
private _result = [];

{
	_result pushBack format ["%1: %2", _x, _y select 1];
} forEach _availableCommands;

_result sort true;

[_computer, _result] call AE3_armaos_fnc_shell_stdout;