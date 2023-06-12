params["_module", "_syncedUnits", "_activated"];

// if triggered in zeus/curator mode, don't run; Could happen in hosted multiplayer
if (!isNull curatorCamera) exitWith {};

if (!isServer) exitWith {};

[_module, _syncedUnits] spawn
{
	params["_module", "_syncedUnits"];

	waitUntil { !isNil "BIS_fnc_init" };

	//--- Extract the user defined module arguments
	private _username = _module getVariable ["AE3_ModuleUserlist_User", ""];
	private _password = _module getVariable ["AE3_ModuleUserlist_Password", ""];

	if ("_username" isEqualTo "") exitWith {};
	if ("_password" isEqualTo "") exitWith {};

	{
		//--- Add user to every synced computer
		[_x, _username, _password] call AE3_armaos_fnc_computer_addUser;
	} foreach _syncedUnits;
};

deleteVehicle _module;

true