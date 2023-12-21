/**
 * Initializes a solar panel.
 * 
 * Arguments:
 * 0: Solar panel <OBJECT>
 * 1: Maximum power output <FLOAT>
 * 2: Function which returns a list of normal vectors for each solar panel <CODE>
 * 3: Height of the solar panel <FLOAT>
 *
 * Returns:
 * None
 */

params ["_entity", "_powerMax", "_orientationFnc", "_height"];

if(!isDedicated) then
{
	private _power = ["AE3_PowerAction", localize "STR_AE3_Power_Interaction_CheckPowerOutput", "", 
				{params ["_target", "_player", "_params"]; _handle = [_target] spawn AE3_power_fnc_checkPowerOutputAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

	private _parentActionPath = _entity getVariable ["AE3_parentActionPath", ""];

	[_entity, 0, _parentActionPath, _power] call ace_interact_menu_fnc_addActionToObject;
};

if(isServer) then
{
	_entity setVariable ["AE3_power_powerMax", _powerMax, true];
	_entity setVariable ["AE3_power_connectedDevices", [], true];
	
	_entity setVariable ["AE3_power_orientationFnc", _orientationFnc];
	_entity setVariable ["AE3_power_height", _height];
};