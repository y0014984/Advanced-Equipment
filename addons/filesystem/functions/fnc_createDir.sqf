/**
 * Creates a directory.
 *
 * Arguments:
 * 1: Pointer <[STRING]>
 * 2: Filesystem <HASHMAP>
 * 3: New directory <STRING>
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target'];

private _dir = [_pntr, _filesystem, _target, true] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

if(_new in _current) then {
	throw _new + " already exists!";
};

_current set [_new, createHashMap];