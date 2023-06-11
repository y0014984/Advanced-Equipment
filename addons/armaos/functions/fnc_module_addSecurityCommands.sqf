params["_logic", "_units", "_activated"];

// if triggered in zeus/curator mode, don't run; Could happen in hosted multiplayer
if (!isNull curatorCamera) exitWith {};

if(!isServer) exitWith {};

[_logic, _units] spawn
{
	params["_logic", "_units"];

	waitUntil { !isNil "BIS_fnc_init" };
	
	//--- Extract the user defined module arguments
	private _isCrypto = _logic getVariable ["AE3_ModuleAddSecurityCommands_IsCrypto", ""];
	private _isCrack = _logic getVariable ["AE3_ModuleAddSecurityCommands_IsCrack", ""];

	{
		[_x, _isCrypto, _isCrack] call AE3_armaos_fnc_computer_addSecurityCommands;
	} foreach _units;
};

true;