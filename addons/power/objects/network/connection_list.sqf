AE3_power_connection_list = [
	["#type", "ConnectionList"],

	["_connections", createHashMap],
	[
		"get_connections",
		{
			params["_device"];

			_device_id = _device call ["get_id"];

			_connections = _self get "_connections";

			if (!(_device_id in _connections)) exitWith {[]};

			_device_connections = _connections get _device_id;

			_device_connections;
		}
	],
	[
		"connect",
		{
			params["_device", "_other_device"];

			_self call ["_disconnect_consumer", [_device]];
			_self call ["_disconnect_consumer", [_other_device]];

			_self call ["_add_to_connection", [_device, _other_device]];
			_self call ["_add_to_connection", [_other_device, _device]];
		}
	],
	[
		"_disconnect_consumer",
		{
			params["_device"];

			if (!("BaseConsumer" in (_device get "#type"))) exitWith {};

			_connections = _self call ["get_connections", [_device]];

			if (count _connections == 0) exitWith {};

			//  Leaf only has max one connection
			_connected_device = _connections select 0;

			_self call ["disconnect", [_device, _connected_device]];
		}
	],
	[
		"_add_to_connection",
		{
			params["_device", "_other_device"];

			_device_id = _device call ["get_id"];
			_connections = _self get "_connections";

			if (!(_device_id in _connections)) then
			{
				_connections set [_device_id, []];
			};

			_connections get _device_id pushBack _other_device;
		}
	],
	[
		"disconnect",
		{
			params["_device", "_other_device"];

			_device_id = _device call ["get_id"];
			_other_device_id = _other_device call ["get_id"];

			_connections = _self get "_connections";

			_connections set [_device_id, (_connections get _device_id) - [_other_device]];
			_connections set [_other_device_id, (_connections get _other_device_id) - [_device]];
		}
	]
];