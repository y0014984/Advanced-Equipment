/**
 * Deletes a fileobjekt.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Path to obj <STRING>
 * 3: User <STRING>
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target', '_user'];

private _dir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _obj = _dir select 2;
_current = _current select 0;

if(!(_obj in _current)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _obj]);

[_current get _obj, _user, 2] call AE3_filesystem_fnc_hasPermission;

_current deleteAt _obj;