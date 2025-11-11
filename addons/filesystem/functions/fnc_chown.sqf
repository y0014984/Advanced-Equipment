/*
 * Author: Root
 * Description: Changes the owner of a filesystem object (file or directory). Can optionally operate recursively on directories. Only the current owner or root can change ownership.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to target file or directory
 * 3: _user <STRING> - User performing the operation
 * 4: _owner <STRING> - New owner name
 * 5: _recursive <BOOL> (Optional, default: false) - Apply recursively to directory contents
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/home/user/file.txt", "root", "user"] call AE3_filesystem_fnc_chown;
 * [[], _filesystem, "/var/www", "root", "www-data", true] call AE3_filesystem_fnc_chown;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_target', '_user', '_owner', ['_recursive', false]];

private _chown = {
	params['_fsObject', '_user', '_owner', '_recursive'];

	private _old = _fsObject select 1;
	if (!(_old isEqualTo _user || _user isEqualTo "root")) then {throw localize "STR_AE3_Filesystem_Exception_MissingPermissions";};

	_fsObject set [1, _owner];

	if (isNil "_recursive") exitWith {};

	if (!((_fsObject select 0) isEqualType createHashMap)) exitWith {}; // Not a directory

	{
		[_y, _user, _owner, _recursive] call _recursive;
	}forEach (_fsObject select 0);
};

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = _dir select 1;
_current = _current select 0;

private _fsObject = _dir select 2;
if(!(_fsObject in _current)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _fsObject]);

if (_recursive) then
{
	[_current get _fsObject, _user, _owner, _chown] call _chown;
}else
{
	[_current get _fsObject, _user, _owner] call _chown;
};
