/**
 * Compiles the device from config for an object's class.
 * Analoge to ACE3 MenuCompile.
 *
 * Argmuments:
 * 0: Entity
 *
 * Returns:
 * None
 *
 */

params['_entity'];


private _class = typeOf _entity;


if(isNil {missionNamespace getVariable _class}) then 
{

	private _deviceCfg = configFile >> "CfgVehicles" >> _class >> "AE3_Device";

	if (isNull _deviceCfg) exitWith 
	{
		missionNamespace setVariable [_class, "", True];
	};

	private _config = createHashMap;
	missionNamespace setVariable [_class, _config, True];

	_config set ['device', [
		getText (_deviceCfg >> "displayName"),
		getNumber (_deviceCfg >> "defaultPowerState"),
		compile (getText (_deviceCfg >> "turnOnAction")),
		compile (getText (_deviceCfg >> "turnOffAction"))
	]];

	private _interface = (_deviceCfg >> "AE3_PowerInterface");
	if(!isNull _interface) then
	{
		_config set ['powerInterface', [
			getArray (_interface >> "connected"),
			[_interface >> "internal"] call BIS_fnc_getCfgDataBool
		]];
	};

	private _battery = (_deviceCfg >> "AE3_Battery");
	if(!isNull _battery) then
	{
		_config set ['battery', [
			getNumber (_battery >> "capacity"),
			getNumber (_battery >> "recharging"),
			getNumber (_battery >> "level"),
			[_battery >> "internal"] call BIS_fnc_getCfgDataBool
		]];
	};

	private _generator = (_deviceCfg >> "AE3_Generator");
	if(!isNull _generator) then
	{
		_config set ['generator', [
			getNumber (_generator >> "fuelCapacity"),
			getNumber (_generator >> "fuelConsumption"),
			getNumber (_generator >> "power"),
			getNumber (_generator >> "fuelLevel")
		]];
	};
};

private _config = missionNamespace getVariable _class;

if(_config isEqualType "") exitWith {};

[_entity] + (_config get 'device') call AE3_power_fnc_initDevice;

if('powerInterface' in _config) then 
{
	[_entity] + (_config get 'powerInterface') call AE3_power_fnc_initPowerInterface;
};

if('battery' in _config) then 
{
	[_entity] + (_config get 'battery') call AE3_power_fnc_initBattery;
};

if('generator' in _config) then 
{
	[_entity] + (_config get 'generator') call AE3_power_fnc_initGenerator;
};