params["_module", "_syncedUnits", "_activated"];

// if triggered in zeus/curator mode, don't run; Could happen in hosted multiplayer
if (!isNull curatorCamera) exitWith {};

if(!isServer) exitWith {};

[_module, _syncedUnits] spawn
{
	params["_module", "_syncedUnits"];

	waitUntil { !isNil "BIS_fnc_init" };

	//--- Extract the user defined module arguments
	private _isSnake = _module getVariable ["AE3_ModuleAddSecurityCommands_IsSnake", ""];

	{
		[_x, _isSnake] call AE3_armaos_fnc_computer_addGames;
	} foreach _syncedUnits;
};

true;