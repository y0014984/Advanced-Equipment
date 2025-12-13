/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Retrieves the content of a file from the filesystem. Checks the specified permission before returning content. Throws exception if file doesn't exist or permission denied.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to file
 * 3: _user <STRING> - User accessing the file
 * 4: _permission <NUMBER> - Permission to check (0: Execute, 1: Read, 2: Write)
 *
 * Return Value:
 * File content (can be string, code, or any stored type) <ANY>
 *
 * Example:
 * [[], _filesystem, "/tmp/data.txt", "root", 1] call AE3_filesystem_fnc_getFile;
 * [_pointer, _filesystem, "../script.sqf", "user", 0] call AE3_filesystem_fnc_getFile;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_target', '_user', '_permission'];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
_current = _current select 0;

private _file = _dir select 2;

if(!(_file in _current)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _file]);

[_current get _file, _user, _permission] call AE3_filesystem_fnc_hasPermission;

(_current get _file) select 0;
