params ["_entity"];

_hasBattery = getNumber (configFile >> "CfgVehicles" >> "Land_Laptop_03_sand_F_AE3" >> "ae3_power_hasBattery");
_batteryCapacity = getNumber (configFile >> "CfgVehicles" >> "Land_Laptop_03_sand_F_AE3" >> "ae3_power_batteryCapacity");
_powerConsumptionOn = getNumber (configFile >> "CfgVehicles" >> "Land_Laptop_03_sand_F_AE3" >> "ae3_power_powerConsumptionOn");
_powerConsumptionStandBy = getNumber (configFile >> "CfgVehicles" >> "Land_Laptop_03_sand_F_AE3" >> "ae3_power_powerConsumptionStandBy");

_batteryLevelPercent = _entity getVariable "AE3_ComputerPowerLevelPercent";
_entity setVariable ["AE3_batteryLevel", _batteryCapacity * _batteryLevelPercent, true];

while {true} do
{
	_powerState = _entity getVariable "AE3_powerState";

	if (_powerState != 0) then
	{
		_consumption = 0;
		switch (_powerState) do
		{
			case 1: { _consumption = _powerConsumptionStandBy; };
			case 2: { _consumption = _powerConsumptionOn; };
			default {};
		};

		_batteryLevel = _entity getVariable "AE3_batteryLevel";

		_newBatteryLevel = _batteryLevel - (_consumption / 3600);

		if (_newBatteryLevel < 0) then
		{
			_newBatteryLevel = 0;

			_class = typeOf _entity;
			switch (_class) do
			{
				case "Land_Laptop_03_sand_F_AE3": { _handle = [_entity, true] execVM "\z\ae3\addons\main\scripts\TurnOffComputerAction.sqf"; };
				default {};
			};
		};

		_entity setVariable ['AE3_batteryLevel', _newBatteryLevel, true];
	};
	
	sleep 1;
};