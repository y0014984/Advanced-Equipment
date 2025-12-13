/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Initializes a battery with capacity, recharging rate, and initial level. Handles both standalone and internal batteries (like laptop batteries). For internal batteries, automatically connects to parent device and starts charging. Battery capacity and recharging rate are in kWh.
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object to initialize
 * 1: _batteryCapacity <NUMBER> - Maximum battery capacity in kWh
 * 2: _recharging <NUMBER> - Recharging rate in kWh
 * 3: _batteryLevel <NUMBER> - (Optional, default: 0) Initial battery level in kWh
 * 4: _internal <BOOL> - (Optional, default: false) Whether this is an internal battery
 *
 * Return Value:
 * None
 *
 * Example:
 * [_battery, 1.5, 0.5, 0.75, false] call AE3_power_fnc_initBattery;
 * [_internalBattery, 0.5, 0.2, 0.25, true] call AE3_power_fnc_initBattery;
 *
 * Public: Yes
 */

params ["_battery", "_batteryCapacity", "_recharging", ["_batteryLevel", 0], ["_internal", false]];

private _entity = _battery;

if(_internal) then
{
	_entity = _battery getVariable 'AE3_power_parent';
};

if(!isDedicated) then {

	private _check = ["AE3_PowerAction", localize "STR_AE3_Power_Interaction_CheckBatteryCharge", "",
				{
					params ['_target', '_player', '_params'];
					_params params ['_battery'];
					_handle = [_battery] spawn AE3_power_fnc_checkBatteryLevelAction;
				},
				{alive _target},
				{},
				[_battery]
				] call ace_interact_menu_fnc_createAction;

	// Ensure equipment parent action exists (creates if needed)
	[_entity] call AE3_interaction_fnc_ensureEquipmentParent;

	private _hasEquipmentAction = _entity getVariable ["AE3_interaction_hasEquipmentAction", false];

	if (_hasEquipmentAction) then {
		// Add to Power submenu for laptops
		[_entity, 0, ["ACE_MainActions", "AE3_EquipmentAction", "AE3_PowerSubmenu"], _check] call ace_interact_menu_fnc_addActionToObject;
	} else {
		// Add to standalone device action
		[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _check] call ace_interact_menu_fnc_addActionToObject;
	};

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

	[_battery, _entity] call AE3_power_fnc_initBatteryLevelWithEdenAttribute;
};
