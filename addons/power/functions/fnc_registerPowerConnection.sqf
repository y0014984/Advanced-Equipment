params ["_from", "_to"];

if (!isServer) exitWith {};

private _power_connections = missionNamespace getVariable ["AE3_power_power_connections", []];
_power_connections pushBack [_from, _to];
missionNamespace setVariable ["AE3_power_power_connections", _power_connections];