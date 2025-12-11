/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Initializes a solar panel with maximum power output, orientation calculation function, and panel height. The orientation function calculates panel normal vectors for solar efficiency calculations. Sets up ACE3 interaction for checking power output.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Solar panel object to initialize
 * 1: _powerMax <NUMBER> - Maximum power output in kWh
 * 2: _orientationFnc <CODE> - Function that returns array of panel normal vectors
 * 3: _height <NUMBER> - Panel height offset in meters for visibility checks
 *
 * Return Value:
 * None
 *
 * Example:
 * [_solarPanel, 2, {[_this] call AE3_power_fnc_multSolarPanelOrientation}, 1.5] call AE3_power_fnc_initSolarPanel;
 *
 * Public: Yes
 */

params ['_entity', '_powerMax', '_orientationFnc', '_height'];

if(!isDedicated) then
{
	private _power = ["AE3_PowerAction", localize "STR_AE3_Power_Interaction_CheckPowerOutput", "", 
				{params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_checkPowerOutputAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _power] call ace_interact_menu_fnc_addActionToObject;
};

if(isServer) then
{
	_entity setVariable ["AE3_power_powerMax", _powerMax, true];
	_entity setVariable ['AE3_power_connectedDevices', [], true];
	
	_entity setVariable ["AE3_power_orientationFnc", _orientationFnc];
	_entity setVariable ["AE3_power_height", _height];
};
