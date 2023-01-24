params["_logic", "_units", "_activated"];

if(!isServer) exitWith {};

private _isCrypto = _logic getVariable ["AE3_ModuleAddSecurityCommands_IsCrypto", ""];
private _isCrack = _logic getVariable ["AE3_ModuleAddSecurityCommands_IsCrack", ""];

[_logic, _units, _isCrypto, _isCrack] spawn
{
	params["_logic", "_units", "_isCrypto", "_isCrack"];

	waitUntil { !isNil "BIS_fnc_init" };

	if (_isCrypto) then
	{
		//--- Add security commands to all synced Computers
		{
			[_x] call AE3_armaos_fnc_securityCommands_init;
		} foreach _units;
	};

	if (_isCrack) then
	{
		//--- Add security commands to all synced Computers
		{
			[_x] call AE3_armaos_fnc_hackingCommands_init;
		} foreach _units;
	};
};

true;