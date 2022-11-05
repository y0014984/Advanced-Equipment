/**
 * Initializes a battery.
 *
 * Arguments:
 * 0: Battery <OBJECT>
 * 1: Battery Capacity <NUMBER>
 * 2: Recharging Rate <NUMBER>
 * 3: Battery Level <NUMEBR> (Optional)
 * 4: If Internal <BOOL> (Optional)
 * 
 * Returns:
 * None
 */

params ["_battery", "_batteryCapacity", "_recharging", ["_batteryLevel", 0], ["_internal", false]];

private _entity = _battery;

if(_internal) then
{
	_entity = _battery getVariable 'AE3_power_parent';
};

if(!isDedicated) then {

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

};

if(isServer) then
{
	_battery setVariable ['AE3_power_batteryCapacity', _batteryCapacity, true];
	_battery setVariable ['AE3_power_batteryLevel', _batteryLevel, true];
	_battery setVariable ['AE3_power_recharging', _recharging, true];
	_battery setVariable ['AE3_power_powerDraw', 0];
	_battery setVariable ['AE3_power_connectedDevices', [], true];

	if(_internal) then
	{
		if(isNil {_entity getVariable "AE3_power_connectedDevices"}) then
		{
			_entity setVariable ['AE3_power_internalBattery', _internal, true];
			_battery setVariable ['AE3_power_connectedDevices', [_entity], true];
			_entity setVariable ["AE3_power_powerCableDevice", _battery, true];
		} else
		{
			_entity setVariable ['AE3_power_connectedDevices', [_battery], true];
			_battery setVariable ["AE3_power_powerCableDevice", _entity, true];
		};

		[_battery] call (_battery getVariable 'AE3_power_fnc_turnOnWrapper');
	};
};