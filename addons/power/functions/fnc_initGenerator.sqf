/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Initializes a fuel-powered generator with fuel capacity, consumption rate, and power output. Sets up ACE3 interactions for checking fuel level and power output. Fuel consumption is in liters per hour, power output is in kWh.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object to initialize
 * 1: _fuelCapacity <NUMBER> - Maximum fuel capacity in liters
 * 2: _fuelConsumption <NUMBER> - Fuel consumption rate in liters per hour
 * 3: _power <NUMBER> - Power output in kWh
 * 4: _fuelLevel <NUMBER> - (Optional, default: 1) Initial fuel level as fraction (0-1)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator, 50, 2.5, 5] call AE3_power_fnc_initGenerator;
 * [_generator, 100, 5, 10, 0.5] call AE3_power_fnc_initGenerator;
 *
 * Public: Yes
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

	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _check] call ace_interact_menu_fnc_addActionToObject;
	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _power] call ace_interact_menu_fnc_addActionToObject;
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
