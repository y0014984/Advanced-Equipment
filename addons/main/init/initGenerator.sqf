params ["_entity"];

// 0 = off; 1 = on
_entity setVariable ["AE3_powerState", 0, true];

// array or nil
_entity setVariable ["AE3_connectedDevices", nil, true];

_handle = [_entity] execVM "\z\ae3\addons\main\scripts\FuelConsumption.sqf";