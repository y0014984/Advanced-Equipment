/**
 * Gets a file from filesystem.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Path to file <STRING>
 * 3: User <STRING>
 * 4: Permission <NUMBER> (0: Execute, 1: Read, 2: Write)
 * Results:
 * Filecontent <any>
 */

params['_pntr', '_filesystem', '_target', '_user', '_permission'];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
_current = _current select 0;

private _file = _dir select 2;

if(!(_file in _current)) throw (format ["'%1' not found!", _file]);

[_current get _file, _user, _permission] call AE3_filesystem_fnc_hasPermission;

(_current get _file) select 0;