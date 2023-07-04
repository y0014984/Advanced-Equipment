/**
 * PRIVATE
 *
 * This function is assigned in module config and will be triggered after mission start and if the module is placed by zeus on every computer.
 * The function will only run on server and only if placed in eden editor. The module will be deleted after processing.
 * The effect of this module applies to all syncted entities.
 *
 * Arguments:
 * 1: Module <OBJECT>
 * 2: Synced Units <[OBJECT]>
 * 3: Activated <BOOL> currently unused in this function
 *
 * Results:
 * None
 *
 */

params ["_module", "_syncedUnits", "_activated"];

// ignore this function if module is placed by curator/zeus
if (_module getvariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith {};

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

	if(_path isEqualTo "") exitWith { deleteVehicle _module; };

	private _isEncrypted = _module getVariable "AE3_Module_AddFile_IsEncrypted";
	private _encryptionAlgorithm = _module getVariable "AE3_Module_AddFile_EncryptionAlgorithm";
	private _encryptionKey = _module getVariable "AE3_Module_AddFile_EncryptionKey";

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