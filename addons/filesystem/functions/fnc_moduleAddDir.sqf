/**
 * Adds a directory, configured via addDir module, to the filesystem of every synced object.
 *
 * Arguments:
 * 0: Module <OBJECT>
 * 1: Synced Units [<OBJECT>]
 *
 * Results:
 * None
 */

params ["_module", "_syncedUnits"];

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

if(_path isEqualTo "") exitWith {};

[_syncedObjects, _path, _owner, _permissions] spawn 
{
	params ["_syncedObjects", "_path", "_owner", "_permissions"];

	waitUntil { !isNil "BIS_fnc_init" };

	{
		_filesystem = _x getVariable "AE3_filesystem";

		// throws exception if directory already exists
		try 
		{
			[
				[],
				_filesystem,
				_path,
				"root",
				_owner,
				_permissions
			] call AE3_filesystem_fnc_createDir;
		} catch { diag_log format ["AE3 exception: %1", _exception]; };

		_x setVariable ["AE3_filesystem", _filesystem];
	} forEach _syncedObjects;
};