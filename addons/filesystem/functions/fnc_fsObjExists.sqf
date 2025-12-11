/*
 * Author: Root
 * Description: Checks whether a filesystem object (file or directory) exists at the specified path. Returns false if path is invalid or object doesn't exist.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to filesystem object
 * 3: _user <STRING> - User performing the check
 *
 * Return Value:
 * True if object exists, false otherwise <BOOL>
 *
 * Example:
 * [[], _filesystem, "/tmp/test.txt", "root"] call AE3_filesystem_fnc_fsObjExists;
 * [_pointer, _filesystem, "../config.cfg", "user"] call AE3_filesystem_fnc_fsObjExists;
 *
 * Public: Yes
 */

params["_pntr", "_filesystem", "_target", "_user"];

try
{
    private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
    private _current = _dir select 1;
    _current = _current select 0;

    private _fsObj = _dir select 2;

    [false, true] select (_fsObj in _current);
} catch
{
    false;
};

