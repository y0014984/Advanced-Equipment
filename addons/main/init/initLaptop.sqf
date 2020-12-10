params ["_entity"];

// 0 = off; 1 = standby; 2 = on
_entity setVariable ["AE3_powerState", 0, true];

// 0 = closed; 1 = opened
_entity setVariable ["AE3_packingState", 1, true];

// 0 = battery; 1 = cable
_entity setVariable ["AE3_powerConsumptionState", 0, true];

// object or nil
_entity setVariable ["AE3_powerCableDevice", nil, true];

_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PowerConsumption.sqf";