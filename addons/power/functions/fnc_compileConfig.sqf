/**
 * Uses the AE3 Device config to compile a hashmap 
 * for the object.
 *
 * Argmuments:
 * 0: Device Config <CONFIG>
 * 1: Config <HASHMAP>
 *
 * Returns:
 * None
 *
 */


params['_deviceCfg', '_config'];

_config set ['device', [
		getText (_deviceCfg >> "displayName"),
		getNumber (_deviceCfg >> "defaultPowerState"),
		compile (getText (_deviceCfg >> "init")),
		compile (getText (_deviceCfg >> "turnOnAction")),
		compile ([_deviceCfg, "turnOnActionCondition", "true"] call BIS_fnc_returnConfigEntry),
		compile (getText (_deviceCfg >> "turnOffAction")),
		compile ([_deviceCfg, "turnOffActionCondition", "true"] call BIS_fnc_returnConfigEntry),
		compile (getText (_deviceCfg >> "standbyAction")),
		compile ([_deviceCfg, "standbyActionCondition", "true"] call BIS_fnc_returnConfigEntry)
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

private _solar = (_deviceCfg >> "AE3_SolarGenerator");
if(!isNull _solar) then
{
	_config set ['solar', [
		getNumber (_solar >> "powerMax"),
		compile (getText (_solar >> "orientationFnc")),
		getNumber (_solar >> "height")
	]];
};

private _consumer = (_deviceCfg >> "AE3_Consumer");
if(!isNull _consumer) then
{
	_config set ['consumer', [
		getNumber (_consumer >> "powerConsumption"),
		getNumber (_consumer >> "standbyConsumption")
	]];
};
