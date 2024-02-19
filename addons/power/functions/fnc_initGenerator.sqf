/**
 * Initializes a generator.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: Fuel Capacity <NUMBER>
 * 2: Fuel Consumption <NUMBER>
 * 3: Power Output <NUMBER>
 * 4: Fuel Level <NUMBER> (Optional)
 *
 * Results:
 * None
*/

params["_entity", "_fuelCapacity", "_fuelConsumption", "_power", ["_fuelLevel", 1]];

if(!isDedicated) then
{
	private _check = ["AE3_PowerAction", localize "STR_AE3_Power_Interaction_CheckFuelLevel", "", 
				{params ["_target", "_player", "_params"]; _handle = [_target] spawn AE3_power_fnc_checkFuelLevelAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

	private _power = ["AE3_PowerAction", localize "STR_AE3_Power_Interaction_CheckPowerOutput", "", 
				{params ["_target", "_player", "_params"]; _handle = [_target] spawn AE3_power_fnc_checkPowerOutputAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

	private _parentActionPath = _entity getVariable ["AE3_parentActionPath", ""];

	[_entity, 0, _parentActionPath, _check] call ace_interact_menu_fnc_addActionToObject;
	[_entity, 0, _parentActionPath, _power] call ace_interact_menu_fnc_addActionToObject;
};

if(isServer) then
{
	_entity setFuel _fuelLevel;
	_entity setVariable ["AE3_power_fuelCapacity", _fuelCapacity, true];
	_entity setVariable ["AE3_power_fuelConsumption", _fuelConsumption, true];
	_entity setVariable ["AE3_power_powerMax", _power, true];
	_entity setVariable ["AE3_power_connectedDevices", [], true];

	[_entity] call AE3_power_fnc_initFuelLevelWithEdenAttribute;
};