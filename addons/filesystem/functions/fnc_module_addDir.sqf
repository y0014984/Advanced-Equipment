/*
 * Author: Root, y0014984
 * Description: Module function for adding directories to devices via Eden editor. Triggered after mission start for synced objects. Only runs on server and ignores Zeus-placed modules. Module is deleted after processing.
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

if(!isServer) exitWith {};

if (_activated) then 
{
	private _syncedObjects = synchronizedObjects _module;

	private _path = _module getVariable ["AE3_Module_AddDir_Path", ""];
	private _owner = _module getVariable ["AE3_Module_AddDir_Owner", ""];
	private _permissions = [
		[
			_module getVariable "AE3_Module_AddDir_OwnerExecute",
			_module getVariable "AE3_Module_AddDir_OwnerRead",
			_module getVariable "AE3_Module_AddDir_OwnerWrite"
		],
		[
			_module getVariable "AE3_Module_AddDir_EveryoneExecute",
			_module getVariable "AE3_Module_AddDir_EveryoneRead",
			_module getVariable "AE3_Module_AddDir_EveryoneWrite"
		]
	];

	// check for empty path, owner and encryption key
	if (_path isEqualTo "") exitWith { deleteVehicle _module; false; };
	if (_owner isEqualTo "") exitWith { deleteVehicle _module; false; };

	// check for not allowed spaces in path and owner
	if((_path find " ") != -1) exitWith { deleteVehicle _module; false; };
	if((_owner find " ") != -1) exitWith { deleteVehicle _module; false; };

	[_module, _syncedObjects, _path, _owner, _permissions] spawn 
	{
		params ["_module", "_syncedObjects", "_path", "_owner", "_permissions"];

		waitUntil { !isNil "BIS_fnc_init" };

		{
			[_x, _path, _owner, _permissions] call AE3_filesystem_fnc_device_addDir;
		} forEach _syncedObjects;

		deleteVehicle _module;
	};
};

true;
