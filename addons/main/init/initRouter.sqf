params ["_entity"];

// 0 = off; 1 = on
_entity setVariable ["AE3_powerState", 0, true];

// 0 = no cable; 1 = cable
_entity setVariable ["AE3_powerConsumptionState", 0, true];

// object or nil
_entity setVariable ["AE3_powerCableDevice", nil, true];

_handle = [_entity] execVM "\z\ae3\addons\main\scripts\PowerConsumption.sqf";

_class = typeOf _entity;

_dhcpCount = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_network_local_dhcpCount");
_dhcpBase = getText (configFile >> "CfgVehicles" >> _class >> "ae3_network_local_dhcpBase");
_dhcpStart = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_network_local_dhcpStart");

_entity setVariable ["AE3_networkDhcpBase", _dhcpBase, true];
_entity setVariable ["AE3_networkDhcpStart", _dhcpStart, true];

_dhcpLeases = [];

for [{ _i = 0 }, { _i < _dhcpCount }, { _i = _i + 1 }] do { _dhcpLeases pushBack -1 };

_entity setVariable ["AE3_dhcpLeases", _dhcpLeases];