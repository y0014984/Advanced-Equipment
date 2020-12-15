params ["_entity"];

_class = typeOf _entity;

_fuelConsumption = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_fuelConsumption");
_fuelCapacity = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_fuelCapacity");

_fuelLevelPercent = _entity getVariable ["AE3_GeneratorFuelLevelPercent",  [configfile >> 'CfgVehicles' >> typeOf _entity, "ae3_power_defaultFuelLevel", -1] call BIS_fnc_returnConfigEntry];
_entity setVariable ["AE3_fuelLevel", _fuelCapacity * _fuelLevelPercent, true];

while {true} do
{
	_powerState = _entity getVariable "AE3_powerState";

	if (_powerState == 1) then
	{
		_fuelLevel = _entity getVariable "AE3_fuelLevel";
		_newFuelLevel = _fuelLevel - (_fuelConsumption / 3600);

		if (_newFuelLevel < 0) then
		{
			_newFuelLevel = 0;

			switch (_class) do
			{
				case "Land_PortableGenerator_01_sand_F_AE3": { _handle = [_entity, true] execVM "\z\ae3\addons\main\scripts\TurnOffGeneratorAction.sqf"; };
				default {};
			};
		};

		_entity setVariable ['AE3_fuelLevel', _newFuelLevel, true];
	};

	sleep 1;
};