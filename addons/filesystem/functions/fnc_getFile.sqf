/**
 * Gets a file from filesystem.
 *
 * Arguments:
 * 1: Pointer <[STRING]>
 * 2: Filesystem <HASHMAP>
 * 3: Path to file <STRING>
 *
 * Results:
 * Filecontent <any>
 */

params['_pntr', '_filesystem', '_target'];

private _path = _target splitString "/";
private _file = _path select (count _path - 1);

_path = (_path select [0, count _path - 1]) joinString "/";

if (_target find "/" == 0) then
{
	_path = "/" + _path;
};

private _dir = [_pntr, _filesystem, _path] call AE3_filesystem_fnc_chdir;

private _current = _dir select 1;

if(!(_file in _current)) throw (format ["'%1' not found!", _file]);

_current get _file;