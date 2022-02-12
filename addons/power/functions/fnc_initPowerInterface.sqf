/**
 * Initializes a power interface
 * 
 * Arguments:
 * 0: Device
 * 1: Connected Devices <[OBJECT]> (Optional)
 * 2: Disables actions (Optional)
 *
 * Results:
 * None
 */

params['_generator', ["_connectedDevices", nil], ['_internal', false]];

private _device = _generator;

if(_internal) then
{
	_device = _generator getVariable 'AE3_parent';
};

_generator setVariable ["AE3_powerCableDevice", nil, true];

private _childs = 
{
	params ['_target', '_player', '_params']; 
	_isBattery = !isNil {_target getVariable 'AE3_batteryCapacity'};

	_generators = (nearestObjects [_target, [], 10]) select {!isNil{_x getVariable 'AE3_connectedDevices'} && _x != _target && !( _isBattery && !isNil{_x getVariable 'AE3_batteryCapacity'}) && !(_x getVariable ['AE3_internalBattery', false])};
	private _actions = []; 
	{ 
		private _childStatement = 
		{ 
			params ['_target', '_player', '_generator']; 

			_device = _target getVariable "AE3_internal";
			if(isNil "_device") then
			{
				_device = _target;
			};

			_handle = [_device, _generator] spawn AE3_power_fnc_connectToGeneratorAction; 
		}; 

		private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; 
		_actions pushBack [_action, [], _target]; 
	} forEach (_generators); _actions
};

_connect = ["AE3_ConnectAction", "Connect to generator", "",
			{},
			{
				params ['_target', '_player', '_params']; 
				_params params ['_device']; 
				(alive _target) and (isNil {_device getVariable 'AE3_powerCableDevice'})
			},
			_childs,
			[_generator]
			] call ace_interact_menu_fnc_createAction;

_disconnect = ["AE3_DisconnectAction", "Disconnect from generator", "",
				{params ['_target', '_player', '_params']; _params params ['_device']; _handle = [_device] spawn AE3_power_fnc_disconnectFromGeneratorAction;},
				{
					params ['_target', '_player', '_params']; 
					_params params ['_device'];
					(alive _target) and (!isNil {_device getVariable 'AE3_powerCableDevice'})
				},
				{},
				[_generator]
				] call ace_interact_menu_fnc_createAction;

[_device, 0, ["ACE_MainActions", "AE3_DeviceAction"], _connect] call ace_interact_menu_fnc_addActionToObject;
[_device, 0, ["ACE_MainActions", "AE3_DeviceAction"], _disconnect] call ace_interact_menu_fnc_addActionToObject;