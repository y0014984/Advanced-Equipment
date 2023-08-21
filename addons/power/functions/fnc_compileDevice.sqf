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

// Protection against double init.
if (_entity getVariable ["AE3_power_initDone", false]) exitWith {};

private _class = (typeOf _entity);
private _class_name = _class + "_power";

if(isNil {missionNamespace getVariable _class_name}) then 
{

	private _deviceCfg = configFile >> "CfgVehicles" >> _class >> "AE3_Device";

	if (!isClass _deviceCfg) exitWith 
	{
		missionNamespace setVariable [_class_name, ""];
	};

	private _config = createHashMap;
	missionNamespace setVariable [_class_name, _config];

	[_deviceCfg, _config] call AE3_power_fnc_compileConfig;

	private _internalCfg = configFile >> "CfgVehicles" >> _class >> "AE3_InternalDevice";

	if (isClass _internalCfg) then
	{
		_config set ["internal", createHashMap];
		[_internalCfg, _config get "internal"] call AE3_power_fnc_compileConfig;	
	};
};

private _config = missionNamespace getVariable _class_name;

// if no power/device config found then exit and set status accordingly
if(_config isEqualType "") exitWith { if (isServer) then { _entity setVariable ["AE3_power_isDevice", false, true]; }; };

// it seems that there is a AE3_Device config, therefore this is a power device
if (isServer) then { _entity setVariable ["AE3_power_isDevice", true, true]; };

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

if ("internal" in _config) then
{
	[_entity, _config] spawn
	{
		params ['_entity', '_config'];

		private _internalConfig = _config get "internal";
		private _internal = _entity getVariable 'AE3_power_internal';

		/* Init internal namespace serverside to prevent race conditions */
		if(isServer) then
		{
			_internal = true call CBA_fnc_createNamespace;

			// "AE3_power_hasInternal" is my only indicator to check, if a device (with or without internal) is completely initialized
			_entity setVariable ['AE3_power_hasInternal', true, true];
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

		if (isServer) then { _entity setVariable ["AE3_power_initDone", true, true]; };
	};
}
else
{
	if (isServer) then { _entity setVariable ["AE3_power_hasInternal", false, true]; };
};

if (isServer) then { _entity setVariable ["AE3_power_initDone", true, true]; };