/**
 * Gets a file from filesystem.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Path to file <STRING>
 * 3: User <STRING>
 *
 * Results:
 * Filecontent <any>
 */

params['_pntr', '_filesystem', '_target', '_user'];

private _dir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
_current = _current select 0;

private _file = _dir select 2;

diag_log str _dir;

if(!(_file in _current)) throw (format ["'%1' not found!", _file]);

[_current get _file, _user] call AE3_filesystem_fnc_hasPermission;

(_current get _file) select 0;