// File: fnc_os_ssh.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Opens an SSH session to another computer over the AE3 network. While the session
 * is active, entered commands are executed against the remote computer's filesystem and the
 * output is shown in the local terminal. End the session with 'exit'. The remote computer is
 * locked (mutex) while the session is active. Interactive programs (games) are blocked.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The local computer object
 * 1: _options <ARRAY> - Command options and arguments: USER@IP PASSWORD
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["admin@192.168.0.5", "secret"], "ssh"] call AE3_armaos_fnc_os_ssh;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["path", "USER@IP", true, false],
			["path", "PASSWORD", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _terminal = _computer getVariable "AE3_terminal";

// Nested SSH sessions are not supported
if (!isNull (_terminal getOrDefault ["AE3_sshTarget", objNull])) exitWith
{
	[_computer, localize "STR_AE3_ArmaOS_Ssh_AlreadyConnected"] call AE3_armaos_fnc_shell_stdout;
};

_ae3OptsThings params ["_userAtIp", "_password"];

private _parts = _userAtIp splitString "@";
if (count _parts != 2) exitWith
{
	[_computer, localize "STR_AE3_ArmaOS_Ssh_Usage"] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};
_parts params ["_user", "_ipString"];

private _targetIp = [_ipString] call AE3_network_fnc_str2ip;
if (_targetIp isEqualTo []) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_InvalidAddress", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

if (AE3_DebugMode || {missionNamespace getVariable ["AE3_NetworkDebugEnabled", false]}) then {
	diag_log text format ["[AE3][ROUTE] ssh source=%1#%2 target=%3 user=%4", [_computer, true] call ace_cargo_fnc_getNameItem, netId _computer, [_targetIp] call AE3_network_fnc_ip2str, _user];
};

// Route to the target over the simulated network (honours each router's external access policy)
([_computer, _targetIp] call AE3_network_fnc_resolve) params ["_target", "_routeLength"];

if (isNull _target || _target isEqualTo _computer) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_NoRoute", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

// Target must be an AE3 computer, running and not in use
if (!(_target getVariable ["AE3_cap_hasTerminal", false])) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_ConnectionRefused", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

// Per-laptop SSH access toggle: refuse when the target has SSH disabled in its attributes.
// Defaults to enabled so existing setups are unaffected.
if (!(_target getVariable ["AE3_ssh_enabled", true])) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_ConnectionRefused", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

if ((_target getVariable ["AE3_power_powerState", 0]) != 1) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_NoRoute", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

if (!([_target] call AE3_armaos_fnc_computer_isFree)) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_TargetBusy", _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

// Validate credentials against the remote user list (root login over ssh follows the same
// rule as local login: it is the target computer that decides whether root may log in)
[_target, "AE3_Userlist"] call AE3_main_fnc_getRemoteVar;
[_target, "AE3_allowRootLogin"] call AE3_main_fnc_getRemoteVar;
private _users = _target getVariable ["AE3_Userlist", createHashMap];

private _rootBlocked = (_user isEqualTo "root") && {!([_target] call AE3_armaos_fnc_computer_allowsRootLogin)};

if (_rootBlocked || {!(_user in _users)} || {(_users get _user) isNotEqualTo _password}) exitWith
{
	[_computer, format [localize "STR_AE3_ArmaOS_Ssh_AuthFailed", _user, _ipString]] call AE3_armaos_fnc_shell_stdout;
	[_computer] call AE3_armaos_fnc_shell_playErrorSound;
};

// Claim the remote computer (same lock as physical terminal access)
_target setVariable ["AE3_computer_mutex", _computer getVariable ["AE3_computer_mutex", objNull], true];

// Pull the remote filesystem and set up a minimal local session context on the target
[_target, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;

private _targetTerminal = createHashMap;
_targetTerminal set ["AE3_terminalLoginUser", _user];
_target setVariable ["AE3_terminal", _targetTerminal];
_target setVariable ["AE3_filepointer", [_user] call AE3_armaos_fnc_shell_getHomeDir];

// Redirect all remote stdout into the local terminal
_target setVariable ["AE3_stdoutRedirect", _computer];

_terminal set ["AE3_sshTarget", _target];

// A session outlives the command that opened it, and either end of it can fall over while the operator
// sits at the prompt: the remote can be shut down, destroyed, packed away or carried out of range, and so
// can the machine they are sitting at. The session is therefore watched rather than only re-tested when
// something is typed, so it closes when it dies instead of when it is next used. The watchdog retires
// itself the moment the session is gone, whichever way it ended.
private _watchdog = [{
	params ["_args", "_handle"];
	_args params ["_computer"];

	private _localTerminal = _computer getVariable ["AE3_terminal", createHashMap];
	private _sessionOver = isNull (_localTerminal getOrDefault ["AE3_sshTarget", objNull]);

	if (_sessionOver || {!([_computer] call AE3_armaos_fnc_shell_sshAlive)}) then {
		[_handle] call CBA_fnc_removePerFrameHandler;
	};
}, 2, [_computer]] call CBA_fnc_addPerFrameHandler;

_terminal set ["AE3_sshWatchdog", _watchdog];

[_target, "System", format [localize "STR_AE3_ArmaOS_Exception_UserLoginSuccessful", _user] + " (ssh)", "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;

[_computer, format [localize "STR_AE3_ArmaOS_Ssh_Connected", _user, _ipString]] call AE3_armaos_fnc_shell_stdout;
