AE3_power_base_device = [
	["#type", "BaseDevice"],
	["id_counter", 0],
	
	["_id", -1],
	["_device_arma_object", objNull],
	["_power_state", objNull],
	["_power", 0],
	
	[
		"#create", 
		{
			params ["_device_object"];
			
			_id_counter = AE3_power_base_device select 1;
			_id = _id_counter select 1;

			_self set ["_id", _id];
			_id_counter set [1, _id + 1];

			_self set ["_device_arma_object", _device_object];

			_storage = createHashMapObject [AE3_power_global_device_storage];
			_storage call ["add_device", [_self]];
			
			_power_state = createHashMapObject [AE3_power_power_state, [0]];
			_self set ["_power_state", _power_state];
		}
	],
	[
		"get_id", {_self get "_id"}
	],
	[
		"turnOn", {(_self get "_power_state") call ["turnOn"]}
	],
	[
		"turnOff", {(_self get "_power_state") call ["turnOff"]}
	],
	[
		"standby", {(_self get "_power_state") call ["standby"]}
	],
	[
		"update_power", 
		{
			_power = _self call ["_calc_power", _this];
			_self set ["_power", _power];

			_power;
		}
	],
	[
		"_calc_power", {throw "NotImplementedError"}
	],
	[
		"get_power", 
		{
			_self get "_power"
		}
	]
];