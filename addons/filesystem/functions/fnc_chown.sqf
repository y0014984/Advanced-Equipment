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