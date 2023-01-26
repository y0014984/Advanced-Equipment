/**
 * Mounts a given filesystem in a specified directory.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Filesystem to mount <HASHMAP>
 * 3: Path to target directory <STRING>
 * 4: User <STRING>
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_mountFilesystem', '_target', '_user'];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;

private _moutingPoint = _dir select 2;
if(!(_moutingPoint in (_current select 0))) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _moutingPoint]);
_current = _current select 0;

[_current get _moutingPoint, _user, 2] call AE3_filesystem_fnc_hasPermission;

_current set [_moutingPoint, _mountFilesystem];