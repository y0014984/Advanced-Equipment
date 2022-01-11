/**
 * Deletes a fileobjekt.
 *
 * Arguments:
 * 1: Pointer <[STRING]>
 * 2: Filesystem <HASHMAP>
 * 3: Path to obj <STRING>
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target'];

private _dir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _obj = _dir select 2;

if(!(_obj in _current)) throw (format ["'%1' not found!", _obj]);

_current deleteAt _obj;