params ["_entity"];

_fuelLevel = _entity getVariable "AE3_fuelLevel";

hint format ["Fuel Level: %1 l", _fuelLevel];