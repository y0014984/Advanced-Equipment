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
		missionNamespace setVariable [_class, ""];
	};

	private _config = createHashMap;
	missionNamespace setVariable [_class, _config];

	[_deviceCfg, _config] call AE3_power_fnc_compileConfig;

	private _internalCfg = configFile >> "CfgVehicles" >> _class >> "AE3_InternalDevice";

	if (!isNull _internalCfg) then
	{
		_config set ["internal", createHashMap];
		[_internalCfg, _config get "internal"] call AE3_power_fnc_compileConfig;	
	};
};

private _config = missionNamespace getVariable _class;

if(_config isEqualType "") exitWith {};

// ================================================================================
// Save all objects in an array, so debug mode can access them
private _debugOverlay = missionNamespace getVariable "AE3_DebugOverlay";
if (isNil "_debugOverlay") then
{
	_debugOverlay = [];
	missionNamespace setVariable ["AE3_DebugOverlay", _debugOverlay, true];
};
_debugOverlay pushBack [_entity, controlNull];
missionNamespace setVariable ["AE3_DebugOverlay", _debugOverlay];
// ================================================================================

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

if('consumer' in _config) then 
{
	[_entity] + (_config get 'consumer') call AE3_power_fnc_initConsumer;
};

if('solar' in _config) then 
{
	[_entity] + (_config get 'solar') call AE3_power_fnc_initSolarPanel;
};

if(!("internal" in _config)) exitWith {};

[_entity, _config] spawn {
	params ['_entity', '_config'];

	private _internalConfig = _config get "internal";
	private _internal = _entity getVariable 'AE3_power_internal';

	/* Init internal namespace serverside to prevent race conditions */
	if(isServer) then
	{
		_internal = true call CBA_fnc_createNamespace;

		_entity setVariable ['AE3_power_internal', _internal, true];
		_internal setVariable ['AE3_power_parent', _entity, true];
	}else
	{
		waitUntil {!isNil {_entity getVariable 'AE3_power_internal';}};
		_internal = _entity getVariable 'AE3_power_internal';
	};

	[_internal] + (_internalConfig get 'device') call AE3_power_fnc_initDevice;

	if('powerInterface' in _internalConfig) then 
	{
		[_internal] + (_internalConfig get 'powerInterface') call AE3_power_fnc_initPowerInterface;
	};

	if('battery' in _internalConfig) then 
	{
		[_internal] + (_internalConfig get 'battery') call AE3_power_fnc_initBattery;
	};

	if('generator' in _internalConfig) then 
	{
		[_internal] + (_internalConfig get 'generator') call AE3_power_fnc_initGenerator;
	};
};