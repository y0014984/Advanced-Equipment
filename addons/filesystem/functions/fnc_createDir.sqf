/**
 * Creates a directory.
 * Permission list is defined by:
 * 0: Permissions for the owner with [execute, read, write]
 * 1: Permissions for everyone with [execute, read, write]
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: New directory <STRING>
 * 3: User <STRING>
 * 4: Owner <String> (Optional)
 * 5: Permission [[<BOOL>]] (Optional)
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target', '_user', '_owner', ['_permissions', [[true, true, true], [false, false, false]]]];

private _dir = [_pntr, _filesystem, _target, _user, true] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

[_current, _user, 2] call AE3_filesystem_fnc_hasPermission;
_current = _current select 0;

if(_new in _current) then {
	throw format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _new];
};

if(isNil '_owner') then
{
	_owner = _user;
};

_current set [_new, [createHashMap, _owner, _permissions]];