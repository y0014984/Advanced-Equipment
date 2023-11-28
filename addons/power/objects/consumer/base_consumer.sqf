AE3_power_base_consumer = [
	["#base", AE3_power_base_device],
	["#type", "BaseConsumer"],

	["_base_power", 0],
	["_standby_power_fraction", 0],
	[
		"#create", 
		{
			params ["_device_object", "_base_power", ["_standby_power_fraction", 1]];

			_self set ["_base_power", _base_power];
			_self set ["_standby_power_fraction", _standby_power_fraction];

			_connector = createHashMapObject [AE3_power_connection_node, [_self]];
			_self set ["_connector", _connector];
		}
	],
	[	
		"_calc_power",
		{
			_power_state = (_self get "_power_state") call ["get_state"];

			if (_power_state == 0) exitWith {0};

			_power = -1 * (_self get "_base_power");

			
			if (_power_state == 2) then {
				_power = _power * (_self get "_standby_power_fraction")
			};

			_power;
		}
	]
];