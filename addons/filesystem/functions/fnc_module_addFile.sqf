// File: fnc_module_addFile.sqf
/*
 * Author: Root, y0014984
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
			_module getVariable "AE3_Module_AddFile_OwnerRead",
			_module getVariable "AE3_Module_AddFile_OwnerWrite",
			_module getVariable "AE3_Module_AddFile_OwnerExecute"
		],
		[
			_module getVariable "AE3_Module_AddFile_EveryoneRead",
			_module getVariable "AE3_Module_AddFile_EveryoneWrite",
			_module getVariable "AE3_Module_AddFile_EveryoneExecute"
		]
	];
	private _isEncrypted = _module getVariable "AE3_Module_AddFile_IsEncrypted";
	private _encryptionAlgorithm = _module getVariable "AE3_Module_AddFile_EncryptionAlgorithm";
	private _encryptionKey = _module getVariable "AE3_Module_AddFile_EncryptionKey";

	// A rejected module used to disappear without a word, which reads exactly like a module that worked
	// until the file turns out to be missing in game. Each rejection now names itself in the log, with
	// the value that caused it, so the reason is one RPT search away instead of a guess.
	private _reject = {
		params ["_reason"];
		diag_log format ["AE3: Add File module skipped - %1 (path: '%2', owner: '%3')", _reason, _path, _owner];
		deleteVehicle _module;
		false
	};

	// check for empty path, owner and encryption key
	if (_path isEqualTo "") exitWith { ["the file path is empty"] call _reject };
	if (_owner isEqualTo "") exitWith { ["the owner is empty"] call _reject };
	if (_encryptionKey isEqualTo "") exitWith { ["the encryption key is empty"] call _reject };

	// check for not allowed spaces in path and owner
	if((_path find " ") != -1) exitWith { ["the file path contains a space, which paths cannot hold"] call _reject };
	if((_owner find " ") != -1) exitWith { ["the owner name contains a space, which user names cannot hold"] call _reject };

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
