/*
 * Author: Root, y0014984
 * Description: Eden/Zeus module function to add games to synced computers.
 *
 * Arguments:
 * 0: _module <STRING> - TODO: Add description
 * 1: _syncedUnits <STRING> - TODO: Add description
 * 2: _activated <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_module, _syncedUnits, _activated] call AE3_armaos_fnc_module_addGames;
 *
 * Public: No
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
		private _isSnake = _module getVariable ["AE3_ModuleAddGames_IsSnake", ""];

		{
			[_x, _isSnake] call AE3_armaos_fnc_computer_addGames;
		} forEach _syncedUnits;

		deleteVehicle _module;
	};
};

true;
