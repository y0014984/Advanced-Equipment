/**
 * Creates a directory.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: New directory <STRING>
 * 3: User <STRING>
 * 4: Owner <String> (Optional)
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target', '_user', '_owner'];

private _dir = [_pntr, _filesystem, _target, true] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

[_current, _user] call AE3_filesystem_fnc_hasPermission;
_current = _current select 0;

if(_new in _current) then {
	throw _new + " already exists!";
};

if(isNil '_owner') then
{
	_owner = _user;
};

_current set [_new, [createHashMap, _owner]];