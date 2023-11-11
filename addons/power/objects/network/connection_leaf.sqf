AE3_power_connection_leaf = [
	["#type", "ConnectionLeaf"],

	["_connection", objNull],

	[
		"#create", 
	{
		_self set ["_connection", objNull];
	}
	],
	[
		"connect",
		{
			params["_other"];

			if (!("ConnectionNode" in (_other get "#type"))) exitWith {};

			if (!isNull (_self get "_connection")) then
			{
				_self call ["disconnect"];
			};
			
			_other call ["connect", [_self]];
		}
	],
	[
		"disconnect",
		{
			_connected = _self get "_connection";

			_connected call ["disconnect", [_self]];
		}
	],
	[
		"set_connection",
		{
			params["_other"];
			_self set ["_connection", _other];
		}
	],
	[
		"get_connections",
		{
			[_self get "_connection"];
		}
	]
]