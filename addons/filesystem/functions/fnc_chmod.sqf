// File: fnc_chmod.sqf
/*
 * Author: Root
 * Description: Changes filesystem permissions on a file or directory. Root can change any object;
 * non-root users can change only objects they own. Directories can be updated recursively.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to target file or directory
 * 3: _user <STRING> - User performing the operation
 * 4: _permissions <ARRAY> - Permissions [[owner r,w,x],[everyone r,w,x]]
 * 5: _recursive <BOOL> (Optional, default: false) - Apply recursively to directory contents
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/home/user/file.txt", "user", [[true,true,false],[true,false,false]]] call AE3_filesystem_fnc_chmod;
 *
 * Public: Yes
 */

params ["_pntr", "_filesystem", "_target", "_user", "_permissions", ["_recursive", false]];

private _apply = {
	params ["_fsObject", "_user", "_permissions", "_recursive", "_apply"];

	private _owner = _fsObject select 1;
	if (!(_user isEqualTo "root" || _owner isEqualTo _user)) then {
		throw localize "STR_AE3_Filesystem_Exception_MissingPermissions";
	};

	_fsObject set [2, _permissions];

	if (!_recursive) exitWith {};
	if (!((_fsObject select 0) isEqualType createHashMap)) exitWith {};

	{
		[_y, _user, _permissions, true, _apply] call _apply;
	} forEach (_fsObject select 0);
};

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = (_dir select 1) select 0;
private _fsObjectName = _dir select 2;

if (!(_fsObjectName in _current)) then {
	throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _fsObjectName]);
};

[_current get _fsObjectName, _user, _permissions, _recursive, _apply] call _apply;
