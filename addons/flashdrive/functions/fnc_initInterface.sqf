/**
 * Initializes a interface.
 * 
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Interface config <ARRAY>
 *
 * Results:
 * None
*/

params ["_device", "_config"];

private _flash_drives = {
	params ["_target", "_player", "_params"];
	_params params ["_config"];

	private _actions = [];
	private _class = configFile >> "CfgWeapons" >> "Item_FlashDisk_AE3";

	private _add = {
		params ["_target", "_player", "_params"];
		([_target] + _params) spawn AE3_flashdrive_fnc_connectFlashDrive;
	};

	{
		_config params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		private _action = [_name, "USB Stick", "", _add, {true}, {}, [_x, _config]] call ace_interact_menu_fnc_createAction; 
		_actions pushBack [_action, [], _target];
	} forEach (items _player select {inheritsFrom (configFile >> "CfgWeapons" >> _x) == _class});

	_actions;
};

private _children = {
	params ["_target", "_player", "_params"];
	_params params ['_flash_drives'];
	private _interfaces = _target getVariable "AE3_USB_Interfaces";

	private _actions = [];
	
	private _condition = 
	{
		params ["_target", "_player", "_params"];
		(_params select 0) params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		isNull _occupied;
	};
	
	{
		_y params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		
		private _action = [_name, _name, "", {hint "Test";}, _condition, _flash_drives, [_y]] call ace_interact_menu_fnc_createAction;  
		_actions pushBack [_action, [], _target];
	} forEach _interfaces;

	_actions;
};

private _connect = ["AE3_USBInterfaceConnectAction", "Connect Flash Drive", "",
			{},
			{
				params ["_target", "_player", "_params"]; 
				private _class = configFile >> "CfgWeapons" >> "Item_FlashDisk_AE3";
				(0 < count (items _player select {inheritsFrom (configFile >> "CfgWeapons" >> _x) == _class})) and (alive _target) 
			},
			_children,
			[_flash_drives]
			] call ace_interact_menu_fnc_createAction;


private _disconnect_children = {
	params ["_target", "_player", "_params"];

	private _interfaces = _target getVariable "AE3_USB_Interfaces";
	private _actions = [];

	private _condition = 
	{
		params ["_target", "_player", "_params"];
		(_params select 0) params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		!(isNull _occupied);
	};

	private _remove = 
	{
		params ["_target", "_player", "_params"];
		([_target, _player] + _params)  spawn AE3_flashdrive_fnc_disconnectFlashDrive;
	};

	{
		_y params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		
		private _action = [_name, format ["%1 - (%2)", _name, _occupied], "", _remove, _condition, {}, [_y]] call ace_interact_menu_fnc_createAction;  
		_actions pushBack [_action, [], _target];
	} forEach _interfaces;

	_actions;
};

private _disconnect = ["AE3_USBInterfaceConnectAction", "Disconnect Flash Drive", "",
			{},
			{
				params ["_target", "_player", "_params"]; 
				private _interfaces = _target getVariable "AE3_USB_Interfaces";
				private _result = false;
				{
					_y params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
					_result = _result || (!(isNull _occupied));
				} forEach _interfaces;
				_result;
			},
			_disconnect_children,
			[]
			] call ace_interact_menu_fnc_createAction;

if(!isDedicated) then
{
	[_device, 0, ["ACE_MainActions"], _connect] call ace_interact_menu_fnc_addActionToObject;
	[_device, 0, ["ACE_MainActions"], _disconnect] call ace_interact_menu_fnc_addActionToObject;
};

_device setVariable ["AE3_USB_Interfaces", _config];
