/**
 * Initializes a battery.
 *
 * Arguments:
 * 
 */

params ["_entity", "_batteryCapacity", "_recharging", ["_batteryLevel", 0], ["_internal", false]];

_entity setVariable ['AE3_batteryCapacity', _batteryCapacity];
_entity setVariable ['AE3_batteryLevel', 0];
_entity setVariable ['AE3_recharging', _recharging];
_entity setVariable ['AE3_powerDraw', 0];
_entity setVariable ['AE3_connectedDevices', []];

private _check = ["AE3_PowerAction", "Check Battery Charge", "", 
				{params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_checkBatteryLevelAction;}, 
				{alive _target}] call ace_interact_menu_fnc_createAction;

[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _check] call ace_interact_menu_fnc_addActionToObject;

if(_internal) then
{
	// TODO: Connect to itself
};