params ["_entity"];

_class = typeOf _entity;

_batteryLevel = _entity getVariable "AE3_batteryLevel";
_batteryCapacity = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_batteryCapacity");
_batteryLevelPercent = (_batteryLevel / _batteryCapacity) * 100;
hint format ["Battery Level: %1 Wh (%2%3)", _batteryLevel, _batteryLevelPercent, "%"];