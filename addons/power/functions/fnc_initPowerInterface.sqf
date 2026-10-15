// File: fnc_initPowerInterface.sqf
/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Initializes power connection interface for a device. Sets up ACE3 interactions for connecting to and disconnecting from nearby power sources. Creates dynamic child menus listing available generators and batteries within 10m. Handles both internal and external power interfaces.
 *
 * Arguments:
 * 0: _generator <OBJECT> - Device with power interface
 * 1: _connectedDevices <ARRAY> - (Optional, default: nil) Pre-connected devices
 * 2: _internal <BOOL> - (Optional, default: false) Whether this is an internal interface
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, nil, false] call AE3_power_fnc_initPowerInterface;
 *
 * Public: No
 */

params["_generator", ["_connectedDevices", nil], ["_internal", false]];

private _childs = 
{
	params ["_target", "_player", "_params"];
	private _isBattery = !isNil {_target getVariable "AE3_power_batteryCapacity"};

	private _generators = (nearestObjects [_target, [], 10]) select
	{
		!isNil{_x getVariable "AE3_power_connectedDevices"} && 
		_x != _target && 
		!(
			_isBattery && 
			!isNil{_x getVariable "AE3_power_batteryCapacity"}
		) && 
		!(_x getVariable ["AE3_power_internalBattery", false])};
	
	private _actions = []; 
	{ 
		private _childStatement = 
		{ 
			params ["_target", "_player", "_generator"]; 

			private _device = _target getVariable "AE3_power_internal";
			if(isNil "_device") then
			{
				_device = _target;
			};

			[_device, _generator] spawn AE3_power_fnc_connectToGeneratorAction;
		}; 

		private _aceCargoName = [_x, true] call ace_cargo_fnc_getNameItem; // changed from {typeOf _x} to this function

		private _action = [_aceCargoName, _aceCargoName, "", _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; 
		_actions pushBack [_action, [], _target]; 
	} forEach (_generators); _actions
};

private _connect = ["AE3_ConnectAction", localize "STR_AE3_Power_Interaction_ConnectToPowerSource", "",
			{},
			{
				params ["_target", "_player", "_params"]; 
				_params params ["_device"]; 
				(alive _target) and (isNil {_device getVariable "AE3_power_powerCableDevice"})
			},
			_childs,
			[_generator]
			] call ace_interact_menu_fnc_createAction;

private _disconnect = ["AE3_DisconnectAction", localize "STR_AE3_Power_Interaction_DisconnectFromPowerSource", "",
				{params ["_target", "_player", "_params"]; _params params ["_device"]; [_device] spawn AE3_power_fnc_disconnectFromGeneratorAction;},
				{
					params ["_target", "_player", "_params"]; 
					_params params ["_device"];
					(alive _target) and (!isNil {_device getVariable "AE3_power_powerCableDevice"})
				},
				{},
				[_generator]
				] call ace_interact_menu_fnc_createAction;

private _device = _generator;

if(_internal) then
{
	_device = _generator getVariable "AE3_power_parent";
};

if(!isDedicated) then
{
	// Ensure equipment parent action exists (creates if needed)
	[_device] call AE3_interaction_fnc_ensureEquipmentParent;

	// The equipment parent is the only node an AE3 device ever hangs its actions from, so the power
	// connections go into a Hardware submenu underneath it.
	private _parentPath = ["ACE_MainActions", "AE3_EquipmentAction"];
	private _hasHardwareSubmenu = _device getVariable ["AE3_interaction_hasHardwareSubmenu", false];

	if (!_hasHardwareSubmenu) then {
		private _hardwareSubmenu = ["AE3_HardwareSubmenu", "Hardware", "", {}, {true}] call ace_interact_menu_fnc_createAction;
		[_device, 0, _parentPath, _hardwareSubmenu] call ace_interact_menu_fnc_addActionToObject;
		_device setVariable ["AE3_interaction_hasHardwareSubmenu", true];
	};

	[_device, 0, _parentPath + ["AE3_HardwareSubmenu"], _connect] call ace_interact_menu_fnc_addActionToObject;
	[_device, 0, _parentPath + ["AE3_HardwareSubmenu"], _disconnect] call ace_interact_menu_fnc_addActionToObject;
};

if(isServer) then
{	
	_generator setVariable ["AE3_power_powerCableDevice", nil, true];
};
