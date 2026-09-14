// File: fnc_os_unlock.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Opens a password-protected file ("AE3_LOCKED|password|content" format) and
 * prints its content. With -p the file is permanently unlocked (rewritten as plain content,
 * requires write permission). Wrong passwords are logged to /var/log/auth.log.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command options and arguments: [-p] FILEPATH PASSWORD
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["/home/user/secret.txt", "hunter2"], "unlock"] call AE3_armaos_fnc_os_unlock;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts =
	[
		["_permanent", "p", "permanent", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Unlock_permanent"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
			["path", "FILEPATH", true, false],
			["path", "PASSWORD", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = []; private _permanent = false;
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

_ae3OptsThings params ["_path", "_password"];

private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";

// Superusers act as root over the filesystem here, exactly as they do in the desktop file manager.
private _username = [_computer] call AE3_armaos_fnc_shell_getFsUser;

try
{
	private _content = [_pointer, _filesystem, _path, _username, 0] call AE3_filesystem_fnc_getFile;

	if (!(_content isEqualType "")) exitWith
	{
		[_computer, format [localize "STR_AE3_ArmaOS_Exception_UnableToRead", _path]] call AE3_armaos_fnc_shell_stdout;
	};

	([_content] call AE3_armaos_fnc_shell_parseLockedFile) params ["_locked", "_filePassword", "_payload"];

	if (!_locked) exitWith
	{
		[_computer, format [localize "STR_AE3_ArmaOS_Unlock_NotLocked", _path]] call AE3_armaos_fnc_shell_stdout;
	};

	if (_filePassword isNotEqualTo _password) exitWith
	{
		[_computer, localize "STR_AE3_ArmaOS_Unlock_WrongPassword"] call AE3_armaos_fnc_shell_stdout;
		[_computer, "System", format ["unlock: wrong password for '%1' (user '%2')", _path, _username], "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;
		[_computer] call AE3_armaos_fnc_shell_playErrorSound;
	};

	[_computer, _payload splitString endl] call AE3_armaos_fnc_shell_stdout;

	if (_permanent) then
	{
		[_pointer, _filesystem, _path, _username, _payload, false] call AE3_filesystem_fnc_writeToFile;

		// Respect filesystem sync mode CBA setting
		private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
		private _syncFlag = [2, true] select (_syncMode == 1);
		_computer setVariable ["AE3_filesystem", _filesystem, _syncFlag];

		[_computer, format [localize "STR_AE3_ArmaOS_Unlock_Permanent", _path]] call AE3_armaos_fnc_shell_stdout;
	};
}
catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};
