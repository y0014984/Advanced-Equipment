/**
 * Compiles the equipment from config for an object's class.
 * Analoge to ACE3 MenuCompile.
 *
 * Argmuments:
 * 0: Equipment <OBJECT>
 *
 * Returns:
 * None
 *
 */

params["_equipment"];

private _class = typeOf _equipment;

private _equipmentConfigVarName = _class + "_Equipment";

if(isNil {missionNamespace getVariable _equipmentConfigVarName}) then 
{
	private _equipmentCfg = configFile >> "CfgVehicles" >> _class >> "AE3_Equipment";

	if (isNull _equipmentCfg) exitWith 
	{
		missionNamespace setVariable [_equipmentConfigVarName, ""];
	};

	private _config = createHashMap;
	missionNamespace setVariable [_equipmentConfigVarName, _config];

	[_equipmentCfg, _config] call AE3_interaction_fnc_compileConfig;
};

private _config = missionNamespace getVariable _equipmentConfigVarName;

if(_config isEqualType "") exitWith {};

[_equipment] + (_config get "equipment") + [(_config get "animationPoints")] call AE3_interaction_fnc_initInteraction;

/* ---------------------------------------- */

if('ace3Interactions' in _config) then 
{
	private _aceDragging = [];
	if('aceDragging' in _config) then
	{
		_aceDragging = (_config get 'aceDragging');
	};

	private _aceCarrying = [];
	if('aceCarrying' in _config) then
	{
		_aceCarrying = (_config get 'aceCarrying');
	};

	private _aceCargo = [];
	if('aceCargo' in _config) then
	{
		_aceCargo = (_config get 'aceCargo');
	};

	[_equipment] + [_aceDragging] + [_aceCarrying] + [_aceCargo] call AE3_interaction_fnc_initAce3Interactions;
};