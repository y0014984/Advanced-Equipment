
{
	[_x] remoteExecCall ["AE3_power_fnc_compileDevice", 0];
} forEach (8 allObjects 8);

private _power_connections = missionNamespace getVariable ["AE3_power_power_connections", []];
{
	_x call AE3_power_fnc_createPowerConnection;
} forEach _power_connections;

["All", "Init", {_this call AE3_power_fnc_compileDevice}, true, [], false] call CBA_fnc_addClassEventHandler;