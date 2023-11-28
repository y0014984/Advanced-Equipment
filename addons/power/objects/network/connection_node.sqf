AE3_power_connection_node = [
	["#type", "ConnectionNode"],

	["_connections", objNull],
	["_device", objNull],

	[
		"#create", 
		{
			params['_device'];

			_self set ["_connections", []];
			_self set ["_device", _device];
		}
	],
	[
		"get_device",
		{
			_self get "_device";
		}
	],
	[
		"connect",
		{
			params["_other"];
			
			if (_other isEqualRef _self) exitWith {};

			_connections = _self get "_connections";
			_connections pushBackUnique _other;

			if ("ConnectionNode" in (_other get "#type")) exitWith
			{				
				_other_connections = _other get "_connections";
				_other_connections pushBackUnique _self;
			};

			if ("ConnectionLeaf" in (_other get "#type")) exitWith
			{
				_other call ["set_connection", _self];
			}
		}
	],
	[
		"disconnect",
		{
			params["_other"];

			if (_other isEqualRef _self) exitWith {};

			_connections = _self get "_connections";
			_self set ["_connections", _connections - [_other]];


			if ("ConnectionNode" in (_other get "#type")) exitWith
			{
				_other_connections = _other get "_connections";
				_other set ["_connections", _other_connections - [_self]];
			};

			if ("ConnectionLeaf" in (_other get "#type")) exitWith
			{
				_other call ["set_connection", objNull];
			}
		}
	],
	[
		"get_connections",
		{
			_self get "_connections";
		}
	]
];