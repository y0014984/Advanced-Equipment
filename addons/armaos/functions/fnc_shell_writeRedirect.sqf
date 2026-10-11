// File: fnc_shell_writeRedirect.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Writes captured command output to a file for shell output redirection ("> FILE",
 * ">> FILE"). The path is resolved from the current directory of the executing computer and the
 * write is done as the session's filesystem user, so normal permissions apply. A missing file is
 * created; appended text starts on a new line. Symbolic links are followed; locked and media files
 * cannot be written. The filesystem is published per AE3_Filesystem_SyncMode afterwards.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Executing computer (the SSH target inside a session)
 * 1: _target <STRING> - Target path as typed
 * 2: _append <BOOL> - Append instead of overwrite
 * 3: _text <STRING> - Captured output
 *
 * Return Value:
 * Error message, "" on success <STRING>
 *
 * Example:
 * [_computer, "notes.txt", true, "Hi"] call AE3_armaos_fnc_shell_writeRedirect;
 *
 * Public: No
 */

params ["_computer", "_target", "_append", "_text"];

private _pointer = _computer getVariable ["AE3_filepointer", []];
private _filesystem = _computer getVariable "AE3_filesystem";
if (isNil "_filesystem") exitWith { localize "STR_AE3_ArmaOS_Redirect_NoFilesystem" };

private _user = [_computer] call AE3_armaos_fnc_shell_getFsUser;
// New files belong to the account that is logged in (not the elevated filesystem user).
private _owner = (_computer getVariable ["AE3_terminal", createHashMap]) getOrDefault ["AE3_terminalLoginUser", ""];
if (_owner isEqualTo "") then { _owner = _user; };

private _error = "";

try
{
	private _path = _target;
	private _entry = [];
	private _exists = true;

	try
	{
		_entry = [_pointer, _filesystem, _path, _user] call AE3_filesystem_fnc_getFileEntry;
	}
	catch
	{
		_exists = false;
	};

	// Follow a symbolic link to the file it points at.
	if (_exists && {(_entry select 0) isEqualType ""}) then
	{
		private _linkTarget = [_entry select 0] call AE3_filesystem_fnc_symlinkTarget;
		if (_linkTarget isNotEqualTo "") then
		{
			_path = _linkTarget;
			try
			{
				_entry = [_pointer, _filesystem, _path, _user] call AE3_filesystem_fnc_getFileEntry;
			}
			catch
			{
				_exists = false;
			};
		};
	};

	if (_exists) then
	{
		private _content = _entry select 0;
		if (_content isEqualType createHashMap) throw format [localize "STR_AE3_ArmaOS_Redirect_IsDirectory", _target];
		if (!(_content isEqualType "") || {(_content find "AE3_LOCKED|") == 0} || {(_content find "AE3_MEDIA|") == 0}) throw format [localize "STR_AE3_ArmaOS_Redirect_NotText", _target];

		if (_append && _content isNotEqualTo "") then
		{
			_text = endl + _text;
		};
	}
	else
	{
		// Like a Unix shell, a missing parent directory is an error rather than created on the fly.
		[_pointer, _filesystem, _path, _user] call AE3_filesystem_fnc_getParentDir;
		[_pointer, _filesystem, _path, "", _user, _owner, [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_createFile;
	};

	[_pointer, _filesystem, _path, _user, _text, _append] call AE3_filesystem_fnc_writeToFile;

	private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
	_computer setVariable ["AE3_filesystem", _filesystem, [2, true] select (_syncMode == 1)];
}
catch
{
	_error = _exception;
};

_error
