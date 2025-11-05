/**
 * Initializes a router.
 *
 * Arguemnts:
 * 0: Router <OBJECT>
 * 1: Parent router <OBJECT> (Optional)
 * 2: Ip address <[INT]> (Optional)
 * 3: Internal <BOOL> (Optional)
 *
 * Returns:
 * None
 *
 */

params["_entity", ["_parent", objNull], ["_address", [192, 168, 0, 1]], ["_internal", false]];


private _childs = 
{
	params ["_target", "_player", "_params"]; 

	_routers = (nearestObjects [_target, [], 10]) select {!isNil{_x getVariable "AE3_network_children"} && _x != _target};
	private _actions = []; 
	{ 
		private _childStatement = 
		{ 
			params ["_target", "_player", "_parent"]; 
			[_target, _parent] call AE3_network_fnc_connect_router2router;
		}; 

		private _aceCargoName = [_x, true] call ace_cargo_fnc_getNameItem; // changed from {typeOf _x} to this function

		private _action = [_aceCargoName, _aceCargoName, "", _childStatement, {true}, {}, _x] call ace_interact_menu_fnc_createAction; 
		_actions pushBack [_action, [], _target]; 
	} forEach (_routers);
	
	_actions
};

private _connect = ["AE3_Network_ConnectAction", localize "STR_AE3_Network_Interaction_ConnectToRouter", "",
			{},
			{
				params ["_target", "_player", "_params"]; 
				_params params ["_device"]; 
				(alive _target) and (isNull (_device getVariable ["AE3_network_parent", objNull]))
			},
			_childs,
			[_entity]
			] call ace_interact_menu_fnc_createAction;

private _disconnect = ["AE3_Network_DisconnectAction", localize "STR_AE3_Network_Interaction_DisconnectFromRouter", "",
				{
					params ["_target", "_player", "_params"]; 
					_params params ["_device"]; 
					[_device] call AE3_network_fnc_disconnect;
				},
				{
					params ["_target", "_player", "_params"]; 
					_params params ["_device"];
					(alive _target) and (!isNull (_device getVariable ["AE3_network_parent", objNull]))
				},
				{},
				[_entity]
				] call ace_interact_menu_fnc_createAction;


if (!isDedicated && !_internal) then
{
	// Check if equipment action exists (set by fnc_initInteraction for laptops)
	private _hasEquipmentAction = _entity getVariable ["AE3_interaction_hasEquipmentAction", false];
	private _networkPath = [];

	if (_hasEquipmentAction) then {
		// Nest under existing equipment action with Network submenu
		private _parentPath = ["ACE_MainActions", "AE3_EquipmentAction"];

		// Create Network submenu
		private _networkSubmenu = ["AE3_NetworkSubmenu", "Network", "", {}, {true}] call ace_interact_menu_fnc_createAction;
		[_entity, 0, _parentPath, _networkSubmenu] call ace_interact_menu_fnc_addActionToObject;

		_networkPath = _parentPath + ["AE3_NetworkSubmenu"];
	} else {
		// For non-laptop devices, use existing DeviceAction path
		_networkPath = ["ACE_MainActions", "AE3_DeviceAction"];
	};

	[_entity, 0, _networkPath, _connect] call ace_interact_menu_fnc_addActionToObject;
	[_entity, 0, _networkPath, _disconnect] call ace_interact_menu_fnc_addActionToObject;
};


 if (isServer) then 
 {
	 _entity setVariable ["AE3_network_address", _address, true];

	 _entity setVariable ["AE3_network_parent", _parent, true];

	 _entity setVariable ["AE3_network_children", [], true];
	 _entity setVariable ["AE3_network_addressCatch", createHashMap, true];
	 _entity setVariable ["AE3_network_addressCounter", 0, true];


	if (!isNull _parent) then
	{
		[_entity, _parent] call AE3_network_fnc_connect_router2router;
	};
 };
