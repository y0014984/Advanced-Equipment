/**
 * Initializes a battery.
 *
 * Arguments:
 * 
 */

params ["_battery", "_batteryCapacity", "_recharging", ["_batteryLevel", 0], ["_internal", false]];

private _entity = _battery;

_battery setVariable ['AE3_batteryCapacity', _batteryCapacity];
_battery setVariable ['AE3_batteryLevel', 0];
_battery setVariable ['AE3_recharging', _recharging];
_battery setVariable ['AE3_powerDraw', 0];
_battery setVariable ['AE3_connectedDevices', []];

if(_internal) then
{
	_entity = _battery getVariable 'AE3_parent';
	_battery setVariable ['AE3_connectedDevices', [_entity], true];
	_entity setVariable ["AE3_powerCableDevice", _battery, true];
};

private _check = ["AE3_PowerAction", "Check Battery Charge", "", 
				{
					params ['_target', '_player', '_params']; 
					_params params ['_battery'];
					_handle = [_battery] spawn AE3_power_fnc_checkBatteryLevelAction;
				}, 
				{alive _target},
				{},
				[_battery]
				] call ace_interact_menu_fnc_createAction;

[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _check] call ace_interact_menu_fnc_addActionToObject;

_entity setVariable ['AE3_internalBattery', _internal, true];

if(_internal) then
{
	[_battery] call (_battery getVariable 'AE3_power_fnc_turnOnWrapper');
};