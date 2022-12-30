params["_logic", "_units", "_activated"];

if(!isServer) exitWith {};

[_logic, _units] spawn
{
	params["_logic", "_units"];

	waitUntil { !isNil "BIS_fnc_init" };

	//--- Add hacking commands to all synced Computers
	{
		[_x] call AE3_armaos_fnc_hackingCommands_init;
	} foreach _units;
};

true;