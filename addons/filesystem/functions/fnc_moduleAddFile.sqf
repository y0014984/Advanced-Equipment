params ["_module", "_syncedUnits"];

private _syncedObjects = synchronizedObjects _module;

private _path = _module getVariable ['AE3_ModuleFilesystem_Path', ''];
private _content = _module getVariable ['AE3_ModuleFilesystem_FileContent', ''];
private _user = _module getVariable ['AE3_ModuleFilesystem_FileOwner', ''];

if(_path isEqualTo '') exitWith {};

[_syncedObjects, _path, _content, _user] spawn 
{
	params ['_syncedObjects', '_path', '_content', '_user'];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		[
			[],
			_x getVariable ['AE3_filesystem', createHashMap],
			_path,
			_content
		] call AE3_filesystem_fnc_createFile;
	} forEach _syncedObjects;
};