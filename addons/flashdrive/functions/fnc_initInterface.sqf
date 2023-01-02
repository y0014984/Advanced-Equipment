params ["_device", "_config"];

private _flash_drives = {
	params ["_target", "_player", "_params"];
	_params params ["_config"];

	private _actions = [];
	private _class = configFile >> "CfgWeapons" >> "Item_FlashDisk_AE3";

	{
		_x params ['_occupied', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		_action = [_name, "USB Stick", "", AE3_flashdrive_fnc_connectFlashDrive, {true}, {}, [_x, _config]] call ace_interact_menu_fnc_createAction; 
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
		(_params select 0) params ['_occupied', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		_occupied;
	};

	{
		_x params ['_occupied', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
		_action = [_name, "USB Port " + str _forEachIndex, "", {hint "test"}, {true}, _flash_drives, [_x]] call ace_interact_menu_fnc_createAction; 
		_actions pushBack [_action, [], _target];
	} forEach _interfaces;

	_actions;
};

private _connect = ["AE3_USBInterfaceConnectAction", "Connect Flash Drive", "",
			{},
			{
				params ["_target", "_player", "_params"]; 
				private _class = configFile >> "CfgWeapons" >> "Item_FlashDisk_AE3";
				(0 < count (items _player select {inheritsFrom (configFile >> "CfgWeapons" >> _x) == _class})) //and (alive _target) 
			},
			_children,
			[_flash_drives]
			] call ace_interact_menu_fnc_createAction;

if(!isDedicated) then
{
	[_device, 0, ["ACE_MainActions"], _connect] call ace_interact_menu_fnc_addActionToObject;
};

_device setVariable ["AE3_USB_Interfaces", _config];
