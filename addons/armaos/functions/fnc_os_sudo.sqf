// File: fnc_os_sudo.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Executes a command as root. The current user must be root or listed in
 * /etc/sudoers (one username per line). Used because a computer can forbid a direct root login.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command (and its arguments) to execute
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["cat", "/var/log/auth.log"], "sudo"] call AE3_armaos_fnc_os_sudo;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

if (_options isEqualTo []) exitWith
{
	[_computer, localize "STR_AE3_ArmaOS_Sudo_Usage"] call AE3_armaos_fnc_shell_stdout;
};

// root may always sudo; other users must be listed in /etc/sudoers
private _allowed = [_computer, _username] call AE3_armaos_fnc_computer_isSudoer;

if (!_allowed) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Sudo_NotInSudoers", _username]] call AE3_armaos_fnc_shell_stdout;
	[_computer, "System", format ["sudo: denied for user '%1'", _username], "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

private _command = _options select 0;
private _commandOptions = _options select [1, (count _options) - 1];

// resolve command links the same way the shell does
private _availableCommands = _computer getVariable ['AE3_Links', createHashMap];
if (_command in _availableCommands) then
{
	_command = (_availableCommands get _command) select 0;
};

[_computer, "System", format ["sudo: user '%1' executed '%2'", _username, _options joinString " "], "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;

// Run the command with root privileges, then restore the original user - even if it throws. The
// terminal state is shared by reference, so a restore that is skipped would leave the whole session
// running as root rather than just this one command.
_terminal set ["AE3_terminalLoginUser", "root"];

try
{
	[_computer, _command, _commandOptions] call AE3_armaos_fnc_shell_executeFile;
}
catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};

// The command may have logged the session out (exit) or switched accounts (su); in that case the
// session no longer belongs to the user who invoked sudo and must not be forced back onto them.
if ((_terminal getOrDefault ["AE3_terminalLoginUser", ""]) isEqualTo "root") then
{
	_terminal set ["AE3_terminalLoginUser", _username];
};
