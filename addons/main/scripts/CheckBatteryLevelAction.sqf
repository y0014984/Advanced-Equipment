params ["_entity"];

_batteryLevel = _entity getVariable "AE3_batteryLevel";

hint format ["Battery Level: %1 Wh", _batteryLevel];