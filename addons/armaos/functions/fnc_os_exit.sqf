// File: fnc_os_exit.sqf
/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Logs out the current user and returns to the login screen. Similar to Unix exit command.
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
 * [_computer, [], "exit"] call AE3_armaos_fnc_os_exit;
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

private _ae3OptsSuccess = false;
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _terminal = _computer getVariable "AE3_terminal";

// A session entered through su returns to the account it came from; only the original login is
// actually logged out, so a superuser shell is left rather than the whole terminal.
private _suStack = _terminal getOrDefault ["AE3_terminalSuStack", []];
if (_suStack isNotEqualTo []) exitWith
{
	private _previousUser = _suStack deleteAt (count _suStack - 1);
	_terminal set ["AE3_terminalSuStack", _suStack];
	_terminal set ["AE3_terminalLoginUser", _previousUser];
	_computer setVariable ["AE3_filepointer", [_previousUser] call AE3_armaos_fnc_shell_getHomeDir];

	[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
	[_computer] call AE3_armaos_fnc_terminal_setPrompt;
};

_terminal deleteAt "AE3_terminalLoginUser";
_terminal deleteAt "AE3_terminalInputBuffer";

_terminal deleteAt "AE3_terminalSuStack";

_terminal set ["AE3_terminalApplication", "LOGIN"];
_terminal set ["AE3_terminalPrompt", "LOGIN>"];
_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalRenderedBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];

[_computer] call AE3_armaos_fnc_terminal_addHeader;
