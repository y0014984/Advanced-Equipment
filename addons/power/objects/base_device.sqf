AE3_power_base_device = [
	["#type", "BaseDevice"],

	["_device_arma_object", objNull],
	["_power_state", objNull],
	["_connector", objNull],
	["_power", 0],
	
	[
		"#create", 
		{
			params ["_device_object"];

			_self set ["_device_arma_object", _device_object];

			_storage = createHashMapObject [AE3_power_global_device_storage];
			_storage call ["add_device", [_self]];
			
			_power_state = createHashMapObject [AE3_power_power_state];
			_self set ["_power_state", AE3_power_power_state];
		}
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
		"connect", {(_self get "_connector") call ["connect", _this]}
	],
	[
		"disconnect", {(_self get "_connector") call ["disconnect", _this]}
	],
	[
		"updatePower", 
		{
			_power = _self call ["_calc_power", _this];
			_self set ["_power", _power];
		}
	],
	[
		"_calcPower", {throw "NotImplementedError"}
	],
	[
		"getPower", 
		{
			_self get "_power"
		}
	],
];