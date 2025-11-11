/*
 * Author: Root
 * Description: Compiles the equipment from config for an object's class, analogous to ACE3 MenuCompile.
 * This function parses the AE3_Equipment config for the object's class, creates a hashmap with compiled
 * settings, and initializes the interaction system for the equipment.
 *
 * Arguments:
 * 0: _equipment <OBJECT> - The equipment object to compile interactions for
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_interaction_fnc_compileEquipment;
 *
 * Public: Yes
 */

params["_equipment"];

private _class = typeOf _equipment;

private _equipmentConfigVarName = _class + "_Equipment";

if(isNil {missionNamespace getVariable _equipmentConfigVarName}) then 
{
	private _equipmentCfg = configFile >> "CfgVehicles" >> _class >> "AE3_Equipment";

	if (!isClass _equipmentCfg) exitWith 
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

	private _interactionConditions = [];
	if('interactionConditions' in _config) then
	{
		_interactionConditions = (_config get 'interactionConditions');
	};

	if (isServer || !isMultiplayer) then
	{
		[_equipment] + [_aceDragging] + [_aceCarrying] + [_aceCargo] + [_interactionConditions] call AE3_interaction_fnc_initAce3Interactions;
	};
};
