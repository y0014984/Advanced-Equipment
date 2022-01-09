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

private _dir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
private _file = _dir select 2;

if(!(_file in _current)) throw (format ["'%1' not found!", _file]);

_current get _file;