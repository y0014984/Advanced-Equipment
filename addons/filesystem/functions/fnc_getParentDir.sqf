/**
 * Get parent dir.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Raw path to target directory <STRING>
 * 3: Creates a directory if it is not found <BOOL> (Optional)
 *
 * Results:
 * 0: Absolute path to target dir <[STRING]>
 * 1: Target dir <HASHMAP>
 * 2: Tail <STRING>
 */

params['_pntr', '_filesystem', '_target', ['_create', false]];

private _path = _target splitString "/";
private _new = _path select (count _path - 1);

_path = (_path select [0, count _path - 1]) joinString "/";

if (_target find "/" == 0) then
{
	_path = "/" + _path;
};

private _result = [_pntr, _filesystem, _path, _create] call AE3_filesystem_fnc_chdir;
_result pushBack _new;

_result;