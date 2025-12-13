/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Moves or copies a filesystem object (file or directory) to another location. If copying, requires read permission on source. If moving, requires write permission on source. Always requires write permission on target directory.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _source <STRING> - Path to source object
 * 3: _target <STRING> - Path to target location
 * 4: _user <STRING> - User performing the operation
 * 5: _copy <BOOL> (Optional, default: false) - If true, copy instead of move
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/tmp/old.txt", "/tmp/new.txt", "root"] call AE3_filesystem_fnc_mvObj;
 * [[], _filesystem, "/home/file.txt", "/backup/", "user", true] call AE3_filesystem_fnc_mvObj;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_source', '_target', '_user', ['_copy', false]];

private _sourceDir = [_pntr, _filesystem, _source, _user] call AE3_filesystem_fnc_getParentDir;
private _sourceCurrent = _sourceDir select 1;
private _sourceFile = _sourceDir select 2;

private _targetDir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _targetCurrent = _targetDir select 1;
private _targetNew = _targetDir select 2;

// If the target is a directory which already exists, put source into that dir
if (_targetNew in (_targetCurrent select 0)) then
{
	if (((_targetCurrent select 0) get _targetNew) select 0 isEqualType (createHashMap)) then 
	{
		_target = _target + "/";
	};
};

_sourceCurrent = _sourceCurrent select 0;
if(!(_sourceFile in _sourceCurrent)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _sourceFile]);

if (_copy) then
{
	[_sourceCurrent get _sourceFile, _user, 1] call AE3_filesystem_fnc_hasPermission;
}else
{
	[_sourceCurrent get _sourceFile, _user, 2] call AE3_filesystem_fnc_hasPermission;
};


if((_target find ["/", count _target - 1]) == (count _target - 1)) then 
{
	_targetCurrent = _targetCurrent select 0;
	if(!(_targetNew in _targetCurrent)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _targetNew]);
	_targetCurrent = (_targetCurrent get _targetNew);

	[_targetCurrent, _user, 2] call AE3_filesystem_fnc_hasPermission;
	_targetCurrent = _targetCurrent select 0;

	if(_targetNew in _targetCurrent) throw (format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _targetNew]);

	_targetCurrent set [_sourceFile, _sourceCurrent get _sourceFile];
}else
{
	[_targetCurrent, _user, 2] call AE3_filesystem_fnc_hasPermission;
	_targetCurrent = _targetCurrent select 0;

	if(_targetNew in _targetCurrent) throw (format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _sourceFile]);

	_targetCurrent set [_targetNew, _sourceCurrent get _sourceFile];
};

if(!_copy) then
{
	_sourceCurrent deleteAt _sourceFile;
};
