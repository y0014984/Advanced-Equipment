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
		//--- add 'crypto' command to all synced computers
		{
			[_x, "CfgSecurityCommands", ["crypto"]] call AE3_armaos_fnc_link_init;
		} foreach _units;
	};

	if (_isCrack) then
	{
		//--- add 'crack' command to all synced computers
		{
			[_x, "CfgSecurityCommands", ["crack"]] call AE3_armaos_fnc_link_init;
		} foreach _units;
	};
};

true;