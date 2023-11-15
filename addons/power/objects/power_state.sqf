AE3_power_power_state = [
	["#flags", ["sealed"]],
	["_state", 0],

	[
		"#create", 
		{
			params[["_default_state", 0]];

			_self set ["_state", _default_state];
		}
	],

	[
		"turnOff",
		{
			_self set ["_state", 0];
		}
	],

	[
		"turnOn",
		{
			_self set ["_state", 1];
		}
	],

	[
		"standby",
		{
			_self set ["_state", 2];
		}
	],

	[
		"get_state",
		{
			_self get "_state";
		}
	],

	[
		"#str", 
		{
			_state = _self call ["get_state"];

			if (_state == 0) exitWith
			{
				"off"
			};

			if (_state == 1) exitWith
			{
				"on"
			};

			if (_state == 2) exitWith
			{
				"standby"
			};
		}
	]
];