params ["_entity"];

// 0 = off; 1 = on
_entity setVariable ["AE3_powerState", 0, true];

// array or nil
_entity setVariable ["AE3_connectedDevices", nil, true];

private _class = typeOf _entity;

private _fuelCapacity = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_fuelCapacity");
private _fuelLevelPercent = _entity getVariable ["AE3_GeneratorFuelLevelPercent",  [configfile >> 'CfgVehicles' >> typeOf _entity, "ae3_power_defaultFuelLevel", -1] call BIS_fnc_returnConfigEntry];

_entity setFuel (_fuelLevelPercent);
_entity setVariable ["AE3_fuelLevel", _fuelCapacity * _fuelLevelPercent, true];