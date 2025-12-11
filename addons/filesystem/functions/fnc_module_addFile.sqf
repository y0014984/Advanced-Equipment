/*
 * Author: Root
 * Description: Module function for adding files to devices via Eden editor. Supports code compilation and encryption. Triggered after mission start for synced objects. Only runs on server and ignores Zeus-placed modules. Module is deleted after processing.
 *
 * Arguments:
 * 0: _module <OBJECT> - Module object
 * 1: _syncedUnits <ARRAY> - Array of synced units (not used directly)
 * 2: _activated <BOOL> - Module activation state
 *
 * Return Value:
 * Success state <BOOL>
 *
 * Example:
 * Called automatically by Eden editor module system
 *
 * Public: No
 */

params ["_module", "_syncedUnits", "_activated"];

// ignore this function if module is placed by curator/zeus
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith {};

if (!isServer) exitWith {};

if (_activated) then 
{
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
	private _isEncrypted = _module getVariable "AE3_Module_AddFile_IsEncrypted";
	private _encryptionAlgorithm = _module getVariable "AE3_Module_AddFile_EncryptionAlgorithm";
	private _encryptionKey = _module getVariable "AE3_Module_AddFile_EncryptionKey";

	// check for empty path, owner and encryption key
	if (_path isEqualTo "") exitWith { deleteVehicle _module; false; };
	if (_owner isEqualTo "") exitWith { deleteVehicle _module; false; };
	if (_encryptionKey isEqualTo "") exitWith { deleteVehicle _module; false; };

	// check for not allowed spaces in path and owner
	if((_path find " ") != -1) exitWith { deleteVehicle _module; false; };
	if((_owner find " ") != -1) exitWith { deleteVehicle _module; false; };

	[_module, _syncedObjects, _path, _content, _isCode, _owner, _permissions, _isEncrypted, _encryptionAlgorithm, _encryptionKey] spawn 
	{
		params ["_module", "_syncedObjects", "_path", "_content", "_isCode", "_owner", "_permissions", "_isEncrypted", "_encryptionAlgorithm", "_encryptionKey"];

		waitUntil { !isNil "BIS_fnc_init" };

		{
			[_x, _path, _content, _isCode, _owner, _permissions, _isEncrypted, _encryptionAlgorithm, _encryptionKey] call AE3_filesystem_fnc_device_addFile;
		} forEach _syncedObjects;

		deleteVehicle _module;
	};
};

true;
