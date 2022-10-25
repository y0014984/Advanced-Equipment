params ["_module", "_syncedUnits"];

if(!isServer) exitWith {};

private _syncedObjects = synchronizedObjects _module;

private _path = _module getVariable ['AE3_ModuleFilesystem_Path', ''];
private _content = _module getVariable ['AE3_ModuleFilesystem_FileContent', ''];
private _isFunction = _module getVariable ['AE3_ModuleFilesystem_IsFunction', ''];
private _owner = _module getVariable ['AE3_ModuleFilesystem_FileOwner', ''];
private _permission = [
	[
		_module getVariable 'AE3_ModuleFilesystem_OwnerExecute',
		_module getVariable 'AE3_ModuleFilesystem_OwnerRead',
		_module getVariable 'AE3_ModuleFilesystem_OwnerWrite'
	],
	[
		_module getVariable 'AE3_ModuleFilesystem_EveryoneExecute',
		_module getVariable 'AE3_ModuleFilesystem_EveryoneRead',
		_module getVariable 'AE3_ModuleFilesystem_EveryoneWrite'
	]
];

if(_path isEqualTo '') exitWith {};

if(_isFunction) then
{
	_content = compile _content;
};

[_syncedObjects, _path, _content, _owner, _permission] spawn 
{
	params ['_syncedObjects', '_path', '_content', '_owner', '_permission'];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		_filesystem = _x getVariable "AE3_filesystem";
		[
			[],
			_filesystem,
			_path,
			_content,
			'root',
			_owner,
			_permission
		] call AE3_filesystem_fnc_createFile;
		_x setVariable ["AE3_filesystem", _filesystem];
	} forEach _syncedObjects;
};