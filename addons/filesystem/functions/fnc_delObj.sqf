/*
 * Author: Root
 * Description: Deletes a filesystem object (file or directory). Requires write permission on the object. Throws exception if object doesn't exist.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to object to delete
 * 3: _user <STRING> - User performing the deletion
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/tmp/test.txt", "root"] call AE3_filesystem_fnc_delObj;
 * [_pointer, _filesystem, "../oldfile", "user"] call AE3_filesystem_fnc_delObj;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_target', '_user'];

private _dir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _obj = _dir select 2;
_current = _current select 0;

if(!(_obj in _current)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _obj]);

[_current get _obj, _user, 2] call AE3_filesystem_fnc_hasPermission;

_current deleteAt _obj;
