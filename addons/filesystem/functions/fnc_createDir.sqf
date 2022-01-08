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

private _path = _target splitString "/";
private _new = _path select (count _path - 1);

_path = (_path select [0, count _path - 1]) joinString "/";

if (_target find "/" == 0) then
{
	_path = "/" + _path;
};

private _dir = [_pntr, _filesystem, _path, true] call AE3_filesystem_fnc_chdir;

private _current = _dir select 1;

if(_new in _current) then {
	throw _new + " already exists!";
};

_current set [_new, createHashMap];