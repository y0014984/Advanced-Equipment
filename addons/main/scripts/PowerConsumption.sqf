params ["_entity"];

_class = typeOf _entity;

_hasBattery = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_hasBattery");
_batteryCapacity = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_batteryCapacity");
_powerConsumptionOn = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_powerConsumptionOn");
_powerConsumptionStandBy = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_powerConsumptionStandBy");
_recharging = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_recharging");

_batteryLevelPercent = _entity getVariable ["AE3_ComputerPowerLevelPercent",  [configfile >> 'CfgVehicles' >> typeOf _entity,'ae3_power_defaultPowerLevel', -1] call BIS_fnc_returnConfigEntry];
_entity setVariable ["AE3_batteryLevel", _batteryCapacity * _batteryLevelPercent, true];

while {true} do
{
	_powerConsumptionState = _entity getVariable ["AE3_powerConsumptionState", -1];
	_powerCableDevice = _entity getVariable ["AE3_powerCableDevice", nil];

	//Loading from Generator oder other Power Supply
	if ((_powerConsumptionState == 1) and (!isNil "_powerCableDevice")) then
	{
		if (_powerCableDevice getVariable ["AE3_powerState", 0] == 1) then
		{
			_batteryLevel = _entity getVariable "AE3_batteryLevel";
			_newBatteryLevel = _batteryLevel + (_recharging / 3600);

			if (_newBatteryLevel > _batteryCapacity) then {_newBatteryLevel = _batteryCapacity};

			_entity setVariable ['AE3_batteryLevel', _newBatteryLevel, true];
		};
	};

	/* ---------------------------------------- */ 

	//Power Battery Consumption by the device
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

			switch (_class) do
			{
				case "Land_Laptop_03_sand_F_AE3": { _handle = [_entity, true] execVM "\z\ae3\addons\main\scripts\TurnOffComputerAction.sqf"; };
				default {};
			};
		};

		_entity setVariable ['AE3_batteryLevel', _newBatteryLevel, true];
	};
	
	/* ---------------------------------------- */ 

	sleep 1;
};