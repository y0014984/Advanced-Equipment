/**
 * Creates a file.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: New directory <STRING>
 * 3: Is function <BOOL>
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target', '_content', ['_isFunction', false]];


private _dir = [_pntr, _filesystem, _target, true] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

if(_new in _current) then {
	throw _new + " already exists!";
};

if(_isFunction) then
{
	_content = compile _content;
};

_current set [_new, _content];

_filesystem;