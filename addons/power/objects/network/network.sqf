AE3_power_network = [
	["#flags", ["sealed"]],

	["members", objNull],

	[
		"#create", 
	{
		_self set ["members", []];
	}
	],
	[
		"add_member",
	{
		params["_object"];
		(_self get "members") pushBackUnique _object;
	}
	]
];

AE3_power_network_builder = [
	["#flags", ["sealed"]],

	["_networks", objNull],
	["_visited", objNull],
	
	[
		"#create",
	{
		_self set ["_networks", []];
		_self set ["_visited", []];
	}
	],
	[
		"_add_visited",
	{
		params ["_object"];
		(_self get "_visited") pushBackUnique _object;
	}
	],
	[
		"_was_visited",
	{
		params ["_object"];
		_object in (_self get "_visited");
	}

	],
	[
		"_add_to_last_network",
	{
		params ["_object"];
		_networks = (_self get "_networks");
		
		(_networks select -1) call ["add_member", [_object]];
	}
	],
	[
		"_add_network",
	{
		params ["_object"];
		_networks = (_self get "_networks");
		
		_new_network = createHashMapObject [AE3_power_network];
		_networks pushBack _new_network;
	}
	],
	[
		"_visit_object",
	{
		params ["_object"];
		_self call ["_add_visited", [_object]];
		_self call ["_add_to_last_network", [_object]];

			
		if ("powerCableDevice" in _object) then
		{
			_powerCableDevice = _object get "powerCableDevice";
			if (_self call ["_was_visited", [_object]]) then
			{
				_self call ["_visit_object", [_powerCableDevice]];
			};

		};

		if ("connectedDevices" in _object) then
		{
			_connectedDevices = _object get "connectedDevices";
			if (_self call ["_was_visited", [_object]]) then
			{
				{
					_self call ["_visit_object", [_x]];
				} forEach _connectedDevices;
			};
		};
	}
	],
	[
		"build",
	{
		params ["_objects"];

		{
			if (not (_self call ["_was_visted", [_x]])) then
			{
				_self call ["_add_network"];
				_self call ["_visit_object", [_x]];
			}
		} forEach _objects;
	}
	]
  
];