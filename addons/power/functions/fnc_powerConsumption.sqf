params ["_entity"];

private _class = typeOf _entity;

private _hasBattery = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_hasBattery");
private _powerConsumptionOn = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_powerConsumptionOn");

private _batteryCapacity = 0;
private _powerConsumptionStandBy = 0;
private _recharging = 0;

if (_hasBattery == 1) then 
{
	_batteryCapacity = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_batteryCapacity");
	_powerConsumptionStandBy = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_powerConsumptionStandBy");
	_recharging = getNumber (configFile >> "CfgVehicles" >> _class >> "ae3_power_recharging");

	_batteryLevelPercent = _entity getVariable ["AE3_ComputerPowerLevelPercent",  [configfile >> 'CfgVehicles' >> typeOf _entity, "ae3_power_defaultPowerLevel", -1] call BIS_fnc_returnConfigEntry];
	_entity setVariable ["AE3_batteryLevel", _batteryCapacity * _batteryLevelPercent, true];
};

while {true} do
{
	_powerConsumptionState = _entity getVariable ["AE3_powerConsumptionState", -1];
	_powerCableDevice = _entity getVariable ["AE3_powerCableDevice", nil];

	if (_hasBattery == 1) then 
	{
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
				case 1: { _consumption = _powerConsumptionOn; };
				case 2: { _consumption = _powerConsumptionStandBy; };
				default {};
			};

			_batteryLevel = _entity getVariable "AE3_batteryLevel";

			_newBatteryLevel = _batteryLevel - (_consumption / 3600);

			if (_newBatteryLevel < 0) then
			{
				_newBatteryLevel = 0;

				switch (_class) do
				{
					case "Land_Laptop_03_sand_F_AE3": { _handle = [_entity, true] spawn AE3_armaos_fnc_turnOffComputerAction; };
					default {};
				};
			};

			_entity setVariable ['AE3_batteryLevel', _newBatteryLevel, true];
		};
		
		/* ---------------------------------------- */ 

	}
	else 
	{
		// Power on devices, that have no battery and no power on button, if they are connected to for example a generator, that is running
		if ((_powerConsumptionState == 1) && (!isNil "_powerCableDevice")) then
		{
			if (_powerCableDevice getVariable ["AE3_powerState", 0] == 1) then 
			{
				// 0 = off; 1 = on
				_entity setVariable ["AE3_powerState", 1, true];
			}
			else 
			{
				_entity setVariable ["AE3_powerState", 0, true];
			};
		}
		else 
		{
			_entity setVariable ["AE3_powerState", 0, true];
		};
	};

	sleep 1;
};