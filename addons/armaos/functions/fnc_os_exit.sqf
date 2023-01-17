/**
 * Logs out the current user, so users need to login again.
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

private _terminal = _computer getVariable "AE3_terminal";

_terminal deleteAt "AE3_terminalLoginUser";
_terminal deleteAt "AE3_terminalInputBuffer";

_terminal set ["AE3_terminalApplication", "LOGIN"];
_terminal set ["AE3_terminalPrompt", "LOGIN>"];
_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalRenderedBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];

[_computer] call AE3_armaos_fnc_terminal_addHeader;