/*
 * Author: Root, Wasserstoff
 * Description: Unmounts a filesystem from a mount point by replacing it with an empty directory. Requires write permission on the mount point. Used for detaching external storage devices safely.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Host filesystem object
 * 2: _mountFilesystem <ARRAY> - Mounted filesystem (not used in current implementation)
 * 3: _target <STRING> - Path to mount point directory
 * 4: _user <STRING> - User performing the unmount operation
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, _flashdriveFS, "/mnt/usb", "root"] call AE3_filesystem_fnc_unmount;
 * [_pointer, _filesystem, _externalFS, "/media/drive", "user"] call AE3_filesystem_fnc_unmount;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_mountFilesystem', '_target', '_user'];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;

private _moutingPoint = _dir select 2;
if(!(_moutingPoint in (_current select 0))) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _moutingPoint]);
_current = _current select 0;

[_current get _moutingPoint, _user, 2] call AE3_filesystem_fnc_hasPermission;

private _old = _current get _moutingPoint;

_current set [_moutingPoint, [createHashMap, _old select 0, _old select 1]];
