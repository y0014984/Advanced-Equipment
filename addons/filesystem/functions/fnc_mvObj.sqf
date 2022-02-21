/**
 * Moves or copies a filesystem object to another directory.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Raw path to source obj <STRING>
 * 3: Raw path to target obj <STRING>
 * 4: User <STRING>
 * 5: If the obj should be copied <BOOL>
 *
 * Results:
 * None
 */

params['_pntr', '_filesystem', '_source', '_target', '_user', ['_copy', false]];


private _sourceDir = [_pntr, _filesystem, _source] call AE3_filesystem_fnc_getParentDir;
private _sourceCurrent = _sourceDir select 1;
private _sourceFile = _sourceDir select 2;

private _targetDir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_getParentDir;
private _targetCurrent = _targetDir select 1;
private _targetNew = _targetDir select 2;

[_targetCurrent, _user, 2] call AE3_filesystem_fnc_hasPermission;
_targetCurrent = _targetCurrent select 0;

_sourceCurrent = _sourceCurrent select 0;
if(!(_sourceFile in _sourceCurrent)) throw (format ["'%1' not found!", _sourceFile]);

[_sourceCurrent get _sourceFile, _user, 2] call AE3_filesystem_fnc_hasPermission;

if((_target find ["/", count _target - 1]) == (count _target - 1)) then 
{

	if(!(_targetNew in _targetCurrent)) throw {format ["'%1' not found!", _targetNew]};

	_targetCurrent = _targetCurrent get _targetNew;

	if(_targetNew in _targetCurrent) throw (format ["'%1' already exists!", _sourceFile]);

	_targetCurrent set [_sourceFile, _sourceCurrent get _sourceFile];
}else
{
	if(_targetNew in _targetCurrent) throw (format ["'%1' already exists!", _sourceFile]);

	_targetCurrent set [_targetNew, _sourceCurrent get _sourceFile];
};

if(!_copy) then
{
	_sourceCurrent deleteAt _sourceFile;
};