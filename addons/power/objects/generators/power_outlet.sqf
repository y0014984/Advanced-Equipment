AE3_power_outlet = [
	["#base", AE3_power_base_generator],
	["_output_base_power", 0],
	[
		"#create", 
		{
			params ["_device_object", "_power_output"];

			_self set ["_output_base_power", _power_output];
		}
	],
	[	
		"_calcPower",
		{
			_power_state = (_self get "_power_state") call ["get_state"];

			if (_power_state == 0 || _power_state == 2) exitWith {0};
			if (_power_state == 1) exitWith {_self get "_output_base_power"};
		}
	]
];