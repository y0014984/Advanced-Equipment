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

params["_module", "_syncedUnits", "_activated"];

// ignore this function if module is placed by curator/zeus
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith {};

if(!isServer) exitWith {};

if (_activated) then 
{
	[_module, _syncedUnits] spawn
	{
		params["_module", "_syncedUnits"];

		waitUntil { !isNil "BIS_fnc_init" };
		
		//--- Extract the user defined module arguments
		private _isCrypto = _module getVariable ["AE3_ModuleAddSecurityCommands_IsCrypto", ""];
		private _isCrack = _module getVariable ["AE3_ModuleAddSecurityCommands_IsCrack", ""];

		{
			[_x, _isCrypto, _isCrack] call AE3_armaos_fnc_computer_addSecurityCommands;
		} forEach _syncedUnits;

		deleteVehicle _module;
	};
};

true;
