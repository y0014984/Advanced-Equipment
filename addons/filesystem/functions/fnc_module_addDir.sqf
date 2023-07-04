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

// if triggered in zeus/curator mode, don't run; Could happen in hosted multiplayer
if (!isNull curatorCamera) exitWith {};

if(!isServer) exitWith {};

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

if(_path isEqualTo "") exitWith { deleteVehicle _module; };

[_syncedObjects, _path, _owner, _permissions] spawn 
{
	params ["_syncedObjects", "_path", "_owner", "_permissions"];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		[_x, _path, _owner, _permissions] call AE3_filesystem_fnc_device_addDir;
	} forEach _syncedObjects;

	deleteVehicle _module;
};