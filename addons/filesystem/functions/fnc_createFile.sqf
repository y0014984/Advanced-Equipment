/**
 * Creates a file.
 * Permission list is defined by:
 * 0: Permissions for the owner with [execute, read, write]
 * 1: Permissions for everyone with [execute, read, write]
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: Filepath <STRING>
 * 3: Filecontent <ANY>
 * 4: User <STRING>
 * 5: Owner <STRING> (Optional)
 * 6: Permission [[<BOOL>]] (Optional)
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_target', '_content', '_user', '_owner', ['_permissions', [[false, true, true], [false, false, false]]]];


private _dir = [_pntr, _filesystem, _target, _user, true, _owner, _permissions] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

[_current, _user, 2] call AE3_filesystem_fnc_hasPermission;
_current = _current select 0;

if(_new in _current) then {
	throw _new + " already exists!";
};

if(isNil '_owner') then
{
	_owner = _user;
};

_current set [_new, [_content, _owner, _permissions]];

_filesystem;