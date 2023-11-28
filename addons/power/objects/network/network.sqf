AE3_power_network = [
	["#flags", ["sealed"]],

	["devices", objNull],
	["batteries", objNull],

	[
		"#create", 
	{
		_self set ["devices", []];
		_self set ["batteries", []];
	}
	],
	[
		"add_member",
	{
		params["_device"];

		if ("Battery" in (_device get "#type")) exitWith
		{
			(_self get "batteries") pushBackUnique _device;
		};

		(_self get "devices") pushBackUnique _device;
	}
	]
];

AE3_power_network_builder = [
	["#flags", ["sealed"]],

	["_networks", objNull],
	["_visited", objNull],
	["_connection_list", objNull],
	
	[
		"#create",
	{
		_self set ["_networks", []];
		_self set ["_visited", []];
		_self set ["_connection_list", createHashMapObject [AE3_power_connection_list]];
	}
	],
	[
		"_add_visited",
	{
		params ["_device"];
		(_self get "_visited") pushBackUnique _device;
	}
	],
	[
		"_was_visited",
	{
		params ["_device"];
		_device in (_self get "_visited");
	}

	],
	[
		"_add_to_last_network",
	{
		params ["_device"];
		_networks = (_self get "_networks");
		
		(_networks select -1) call ["add_member", [_device]];
	}
	],
	[
		"_add_network",
	{
		_networks = (_self get "_networks");
		
		_new_network = createHashMapObject [AE3_power_network];
		_networks pushBack _new_network;
	}
	],
	[
		"_visit_object",
	{
		params ["_device"];
		_self call ["_add_visited", [_device]];
		_self call ["_add_to_last_network", [_device]];

		_connection_list = _self get "_connection_list";
		_connected_devices = _connection_list call ["get_connections", [_device]];

		{
			if (!(_self call ["_was_visited", [_x]])) then
			{
				_self call ["_visit_object", [_x]];
			}
		} forEach _connected_devices;

	}
	],
	[
		"build",
	{
		params ["_devices"];

		{
			_device = _x;

			if (!(_self call ["_was_visited", [_device]])) then
			{
				_self call ["_add_network"];
				_self call ["_visit_object", [_device]];
			}
		} forEach _devices;
	}
	],
	[
		"get_networks",
		{
			_self get "_networks";
		}
	]
  
];