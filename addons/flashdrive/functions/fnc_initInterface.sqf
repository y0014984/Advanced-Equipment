/**
 * Initializes a (usb) interface.
 * 
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Interface config <ARRAY>
 * 2: Parent Action Name <STRING>
 *
 * Results:
 * None
*/

params ["_device", "_config", "_parentActionName"];

if(!isDedicated) then
{
	private _parentActionPath = [_device, _parentActionName] call AE3_main_fnc_interaction_addParentAction;
	
	private _flash_drives =
	{
		params ["_target", "_player", "_params"];
		_params params ["_config"];

		private _actions = [];
		private _class = configFile >> "CfgWeapons" >> "Item_FlashDisk_AE3";

		private _add = {
			params ["_target", "_player", "_params"];
			([_target, _player] + _params) remoteExec ["AE3_flashdrive_fnc_connectFlashDrive", 2];
		};

		_config params ["_index", "_name", "_rel_pos", "_rot_yaw", "_rot_pitch", "_rot_roll"];
		{
			private _action = [_name, (getText (configFile >> "CfgWeapons" >> _x >> "displayName")), "", _add, {true}, {}, [_x, _config]] call ace_interact_menu_fnc_createAction; 
			_actions pushBack [_action, [], _target];
		} forEach (items _player select {inheritsFrom (configFile >> "CfgWeapons" >> _x) == _class});

		_actions;
	};

	private _children =
	{
		params ["_target", "_player", "_params"];
		_params params ["_flash_drives"];

		private _interfaces = _target getVariable "AE3_USB_Interfaces";
		private _occupiedList = _target getVariable "AE3_USB_Interfaces_occupied";

		private _actions = [];
		
		private _condition = 
		{
			params ["_target", "_player", "_params"];
			(_params select 0) params ["_index", "_name", "_rel_pos", "_rot_yaw", "_rot_pitch", "_rot_roll"];
			private _occupiedList = _target getVariable "AE3_USB_Interfaces_occupied";

			isNull (_occupiedList select _index);
		};
		
		{
			_y params ["_index", "_name", "_rel_pos", "_rot_yaw", "_rot_pitch", "_rot_roll"];
			
			if (isNull (_occupiedList select _index)) then 
			{
				private _action = [_name, _name, "", {}, _condition, _flash_drives, [_y]] call ace_interact_menu_fnc_createAction;  
				_actions pushBack [_action, [], _target];
			};
		} forEach _interfaces;

		_actions;
	};

	private _connect = ["AE3_USBInterfaceConnectAction", (localize "STR_AE3_Flashdrive_Interaction_Connect"), "",
				{},
				{
					params ["_target", "_player", "_params"]; 
					private _class = configFile >> "CfgWeapons" >> "Item_FlashDisk_AE3";
					(0 < count (items _player select {inheritsFrom (configFile >> "CfgWeapons" >> _x) == _class})) and (alive _target) 
				},
				_children,
				[_flash_drives]
				] call ace_interact_menu_fnc_createAction;

	[_device, 0, _parentActionPath, _connect] call ace_interact_menu_fnc_addActionToObject;
};

if (isServer) then
{
	private _occupied = [];
	private _mounted = [];
	{
		_occupied pushBack objNull;
		_mounted pushBack false;
	} forEach _config;

	_device setVariable ["AE3_USB_Interfaces_occupied", _occupied, true];
	_device setVariable ["AE3_USB_Interfaces_mounted", _mounted, true];
};

_device setVariable ["AE3_USB_Interfaces", _config];