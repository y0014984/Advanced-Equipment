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

params['_entity', ["_connectedDevices", []], ['_internal', false]];

_entity setVariable ["AE3_connectedDevices", _connectedDevices, true];

if(!_internal) then {

	_connect = ["AE3_ConnectAction", "Connect to generator", "",
				{},
				{(alive _target) and (count (nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]) > 0) and (_target getVariable 'AE3_powerConsumptionState' == 0)},
				{params ['_target', '_player', '_params']; _generators = nearestObjects [_target, ['Land_PortableGenerator_01_sand_F_AE3'], 10]; private _actions = []; { private _childStatement = { params ['_target', '_player', '_generator']; _handle = [_target, _generator] spawn AE3_power_fnc_connectToGeneratorAction; }; private _action = [typeOf _x, typeOf _x, '', _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; _actions pushBack [_action, [], _target]; } forEach (_generators); _actions}
				] call ace_interact_menu_fnc_createAction;

	_disconnect = ["AE3_DisconnectAction", "Disconnect from generator", "",
					{params ['_target', '_player', '_params']; _handle = [_target] spawn AE3_power_fnc_disconnectFromGeneratorAction;},
					{(alive _target) and (_target getVariable 'AE3_powerConsumptionState' == 1)}
					] call ace_interact_menu_fnc_createAction;

	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _connect] call ace_interact_menu_fnc_addActionToObject;
	[_entity, 0, ["ACE_MainActions", "AE3_DeviceAction"], _disconnect] call ace_interact_menu_fnc_addActionToObject;
};

