// File: fnc_initRouter.sqf
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

	private _routers = (nearestObjects [_target, [], 10]) select {!isNil{_x getVariable "AE3_network_children"} && _x != _target};
	private _actions = [];
	{
		private _childStatement =
		{
			params ["_target", "_player", "_parent"];
			[_target, _parent, AE3_network_fnc_connect_router2router] call AE3_network_fnc_promptConnect;
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


// Configure Router: opens the in-game settings dialog, the same interaction menu as
// Connect/Disconnect ("like the Turn On/Off menu"). Eden/Zeus use the Configure Router module or the
// object's web admin page; this is the runtime ACE path.
private _configure = ["AE3_Network_ConfigureAction", localize "STR_AE3_Network_Interaction_ConfigureRouter", "",
			{
				params ["_target", "_player", "_params"];
				_params params ["_device"];
				[_device] call AE3_network_fnc_router_openConfig;
			},
			{
				params ["_target", "_player", "_params"];
				_params params ["_device"];
				alive _target && {!isNull _device}
			},
			{},
			[_entity]
			] call ace_interact_menu_fnc_createAction;

if (!isDedicated && !_internal) then
{
	// Ensure equipment parent action exists (creates if needed)
	[_entity] call AE3_interaction_fnc_ensureEquipmentParent;

	private _hasEquipmentAction = _entity getVariable ["AE3_interaction_hasEquipmentAction", false];
	private _networkPath = [];

	if (_hasEquipmentAction) then {
		// Nest under equipment action with Network submenu
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
	[_entity, 0, _networkPath, _configure] call ace_interact_menu_fnc_addActionToObject;
};


 if (isServer) then
 {
	 _entity setVariable ["AE3_cap_isRouter", true, true];

	 // Wireless reach + access control. Defaults come from the CBA setting; a value pre-set by
	 // Eden/Zeus (AE3_network_wirelessRange / AE3_network_password) is preserved. A blank password
	 // means an open network.
	 if (isNil {_entity getVariable "AE3_network_wirelessRange"}) then {
		_entity setVariable ["AE3_network_wirelessRange", missionNamespace getVariable ["AE3_network_defaultWirelessRange", 100], true];
	 } else {
		_entity setVariable ["AE3_network_wirelessRange", _entity getVariable "AE3_network_wirelessRange", true];
	 };
	 if (isNil {_entity getVariable "AE3_network_password"}) then {
		_entity setVariable ["AE3_network_password", "", true];
	 } else {
		_entity setVariable ["AE3_network_password", _entity getVariable "AE3_network_password", true];
	 };

	 // Default gateway. A value pre-set by an Eden attribute / placement module is honoured first; an
	 // explicit address passed to this function is used next; otherwise each router is handed the next
	 // free /24 so no two routers share a subnet: 1st -> 192.168.0.1, 2nd -> 192.168.1.1, and so on.
	 // This applies to cascaded child routers too, so every router stays a distinct gateway.
	 private _gateway = _address;
	 private _preset = _entity getVariable ["AE3_network_address", []];
	 if (count _preset == 4 && {(_preset findIf { if !(_x isEqualType 0) exitWith {true}; _x < 0 || _x > 255 }) == -1}) then
	 {
		_gateway = _preset;
	 }
	 else
	 {
		if (_address isEqualTo [192, 168, 0, 1]) then
		{
			private _idx = missionNamespace getVariable ["AE3_network_rootRouterCount", 0];
			_gateway = [192, 168, _idx % 256, 1];
			missionNamespace setVariable ["AE3_network_rootRouterCount", _idx + 1];
		};
	 };
	 _entity setVariable ["AE3_network_address", _gateway, true];

	 _entity setVariable ["AE3_network_parent", _parent, true];

	 _entity setVariable ["AE3_network_children", [], true];
	 _entity setVariable ["AE3_network_addressCatch", createHashMap, true];
	 _entity setVariable ["AE3_network_addressCounter", 0, true];

	 // External access policy: whether laptops on OTHER gateways may reach devices on this router
	 // (ping/ssh). The optional allow list narrows it to source gateways matching one of its regex
	 // patterns; blank means any gateway once external access is enabled. Eden/Zeus/API presets kept.
	 if (isNil {_entity getVariable "AE3_network_allowExternalSsh"}) then {
		_entity setVariable ["AE3_network_allowExternalSsh", false, true];
	 } else {
		_entity setVariable ["AE3_network_allowExternalSsh", _entity getVariable "AE3_network_allowExternalSsh", true];
	 };
	 if (isNil {_entity getVariable "AE3_network_externalAllow"}) then {
		_entity setVariable ["AE3_network_externalAllow", "", true];
	 } else {
		_entity setVariable ["AE3_network_externalAllow", _entity getVariable "AE3_network_externalAllow", true];
	 };

	 // Global router registry: lets the resolver map a target IP to its owning subnet without a
	 // physical link between gateways. Dead/null entries are skipped at lookup time.
	 private _registry = missionNamespace getVariable ["AE3_network_routers", []];
	 _registry pushBackUnique _entity;
	 missionNamespace setVariable ["AE3_network_routers", _registry, true];


	if (!isNull _parent) then
	{
		[_entity, _parent] call AE3_network_fnc_connect_router2router;
	};
 };
