/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Eden/Zeus module function to add a user account to all synced computers. Only runs on server when placed in Eden editor. Module is deleted after processing.
 *
 * Arguments:
 * 0: _module <OBJECT> - The Eden module object
 * 1: _syncedUnits <ARRAY> - Array of synced computer objects
 * 2: _activated <BOOL> - Module activation state
 *
 * Return Value:
 * Success status <BOOL>
 *
 * Example:
 * [_module, [_computer1, _computer2], true] call AE3_armaos_fnc_module_addUser;
 *
 * Public: No
 */

params["_module", "_syncedUnits", "_activated"];

// ignore this function if module is placed by curator/zeus
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith { false; };

if (!isServer) exitWith {};

if (_activated) then 
{
	[_module, _syncedUnits] spawn
	{
		params["_module", "_syncedUnits"];

		waitUntil { !isNil "BIS_fnc_init" };

		//--- Extract the user defined module arguments
		private _username = _module getVariable ["AE3_ModuleUserlist_User", ""];
		private _password = _module getVariable ["AE3_ModuleUserlist_Password", ""];

		// check for empty username or password
		if (_username isEqualTo "") exitWith { deleteVehicle _module; false; };
		if (_password isEqualTo "") exitWith { deleteVehicle _module; false; };

		// check for not allowed spaces in username
		if((_username find " ") != -1) exitWith { deleteVehicle _module; false; };

		{
			private _computer = _x;

			// Wait for this specific computer to be fully initialized
			waitUntil {
				sleep 0.1;
				_computer getVariable ["AE3_filesystemReady", false]
			};

			//--- Add user to computer
			[_computer, _username, _password] call AE3_armaos_fnc_computer_addUser;
		} forEach _syncedUnits;

		deleteVehicle _module;
	};
};

true;
