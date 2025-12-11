/*
 * Author: Root
 * Description: Creates a new directory in the filesystem. Automatically ensures parent directories have appropriate execute/read permissions. Throws exception if directory already exists.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to new directory
 * 3: _user <STRING> - User creating the directory
 * 4: _owner <STRING> (Optional, default: _user) - Owner of the new directory
 * 5: _permissions <ARRAY> (Optional, default: [[true,true,true],[false,false,false]]) - Permissions [[owner x,r,w],[everyone x,r,w]]
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/tmp/logs", "root"] call AE3_filesystem_fnc_createDir;
 * [[], _filesystem, "/home/user/documents", "user", "user", [[true,true,true],[true,true,false]]] call AE3_filesystem_fnc_createDir;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_target', '_user', '_owner', ['_permissions', [[true, true, true], [false, false, false]]]];

// allow "x" and "r" on parent folder if directory has "r", "w" or "x"
private _parentDirPermissions = +_permissions;
{
	if ((_x select 0) || (_x select 1) || (_x select 2)) then
	{
		_x set [0, true];
		_x set [1, true];
	};
} forEach _parentDirPermissions;

private _dir = [_pntr, _filesystem, _target, _user, true, _owner, _parentDirPermissions] call AE3_filesystem_fnc_getParentDir;

private _current = _dir select 1;
private _new = _dir select 2;

[_current, _user, 2] call AE3_filesystem_fnc_hasPermission;
_current = _current select 0;

if(_new in _current) then
{
	throw format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _new];
};

if(isNil '_owner') then
{
	_owner = _user;
};

_current set [_new, [createHashMap, _owner, _permissions]];
