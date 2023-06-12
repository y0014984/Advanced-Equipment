params["_module", "_syncedUnits", "_activated"];

// if triggered in zeus/curator mode, don't run; Could happen in hosted multiplayer
if (!isNull curatorCamera) exitWith {};

if(!isServer) exitWith {};

[_module, _syncedUnits] spawn
{
	params["_module", "_syncedUnits"];

	waitUntil { !isNil "BIS_fnc_init" };
	
	//--- Extract the user defined module arguments
	private _isCrypto = _module getVariable ["AE3_ModuleAddSecurityCommands_IsCrypto", ""];
	private _isCrack = _module getVariable ["AE3_ModuleAddSecurityCommands_IsCrack", ""];

	{
		[_x, _isCrypto, _isCrack] call AE3_armaos_fnc_computer_addSecurityCommands;
	} foreach _syncedUnits;
};

deleteVehicle _module;

true;