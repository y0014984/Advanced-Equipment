params ["_entity"];

// ===== POWER SETTINGS =====

// 0 = off; 1 = on; 2 = standby
_entity setVariable ["AE3_powerState", 0, true];

// 0 = closed; 1 = opened
_entity setVariable ["AE3_packingState", 1, true];

// 0 = battery; 1 = cable
_entity setVariable ["AE3_powerConsumptionState", 0, true];

// object or nil
_entity setVariable ["AE3_powerCableDevice", nil, true];

_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PowerConsumption.sqf";

// ===== NETWORK SETTINGS =====

// 0 = No Network Connection; 1 = Network Connection
_entity setVariable ["AE3_networkConnectionState", 0, true];

// object or nil
_entity setVariable ["AE3_networkCableDevice", nil, true];

// changes if connected to router
_entity setVariable ["AE3_ipAddress", "127.0.0.1", true];