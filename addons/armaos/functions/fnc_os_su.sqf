// File: fnc_os_su.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Switches the terminal session to another account, defaulting to root. The current user
 * must be root or listed in /etc/sudoers; unlike sudo, which elevates a single command, the switch
 * lasts until exit, which returns to the account the session came from. Used because a computer can
 * forbid a direct root login while still granting its sudoers superuser access.
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
 * [_computer, ["root"], "su"] call AE3_armaos_fnc_os_su;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false]
	],
	[
			["command", _commandName, true, false],
			["user", "USER", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

// root may always switch; other users must be listed in /etc/sudoers
if (!([_computer, _username] call AE3_armaos_fnc_computer_isSudoer)) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Su_NotPermitted", _username]] call AE3_armaos_fnc_shell_stdout;
	[_computer, "System", format ["su: denied for user '%1'", _username], "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

private _target = trim (_ae3OptsThings param [0, "root", [""]]);
if (_target isEqualTo "") then { _target = "root"; };

if (_target isEqualTo _username) exitWith {};

// Only real accounts can be switched to; root exists on every device even when it has no user entry.
private _users = _computer getVariable ["AE3_Userlist", createHashMap];
if (_target isNotEqualTo "root" && {!(_target in _users)}) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Su_UserNotFound", _target]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

// Remember where the session came from so exit returns to it instead of logging out.
private _stack = _terminal getOrDefault ["AE3_terminalSuStack", []];
_stack pushBack _username;
_terminal set ["AE3_terminalSuStack", _stack];

_terminal set ["AE3_terminalLoginUser", _target];
_computer setVariable ["AE3_filepointer", [_target] call AE3_armaos_fnc_shell_getHomeDir];

[_computer, "System", format ["su: user '%1' switched to '%2'", _username, _target], "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;

[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
