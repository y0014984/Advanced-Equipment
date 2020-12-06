params ["_entity"];

// 0 = off; 1 = standby; 2 = on
_entity setVariable ["AE3_powerState", 0, true];

// 0 = closed; 1 = opened
_entity setVariable ["AE3_packingState", 1, true];

// 0 = battery; 1 = cable
_entity setVariable ["AE3_powerConsumptionState", 1, true];

// object or nil
_entity setVariable ["AE3_powerCableDevice", nil, true];

_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PowerConsumption.sqf";

//_handle = [_entity, "Screen", 1, 1, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffAction.sqf";
//_handle = [_entity, "Land_laptop_03_closed_sand_F", "Laptop", 2, 1] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";