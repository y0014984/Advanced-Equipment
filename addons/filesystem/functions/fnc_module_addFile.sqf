/**
 * Adds a file, configured via addFile module, to the filesystem of every synced object.
 *
 * Arguments:
 * 0: Module <OBJECT>
 * 1: Synced Units [<OBJECT>]
 *
 * Results:
 * None
 */

params ["_module", "_syncedUnits", "_activated"];

if (!isServer) exitWith {};

private _syncedObjects = synchronizedObjects _module;

private _path = _module getVariable ["AE3_Module_AddFile_Path", ""];
private _content = _module getVariable ["AE3_Module_AddFile_Content", ""];
private _isCode = _module getVariable ["AE3_Module_AddFile_IsCode", ""];
private _owner = _module getVariable ["AE3_Module_AddFile_Owner", ""];
private _permissions = [
	[
		_module getVariable "AE3_Module_AddFile_OwnerExecute",
		_module getVariable "AE3_Module_AddFile_OwnerRead",
		_module getVariable "AE3_Module_AddFile_OwnerWrite"
	],
	[
		_module getVariable "AE3_Module_AddFile_EveryoneExecute",
		_module getVariable "AE3_Module_AddFile_EveryoneRead",
		_module getVariable "AE3_Module_AddFile_EveryoneWrite"
	]
];

if(_path isEqualTo "") exitWith { deleteVehicle _module; };

private _isEncrypted = _module getVariable "AE3_Module_AddFile_IsEncrypted";
private _encryptionAlgorithm = _module getVariable "AE3_Module_AddFile_EncryptionAlgorithm";
private _encryptionKey = _module getVariable "AE3_Module_AddFile_EncryptionKey";

[_syncedObjects, _path, _content, _isCode, _owner, _permissions, _isEncrypted, _encryptionAlgorithm, _encryptionKey] spawn 
{
	params ["_syncedObjects", "_path", "_content", "_isCode", "_owner", "_permissions", "_isEncrypted", "_encryptionAlgorithm", "_encryptionKey"];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		[_x, _path, _content, _isCode, _owner, _permissions, _isEncrypted, _encryptionAlgorithm, _encryptionKey] call AE3_filesystem_fnc_device_addFile;
	} forEach _syncedObjects;
};

deleteVehicle _module;