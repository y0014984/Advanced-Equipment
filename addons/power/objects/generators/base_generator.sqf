AE3_power_base_generator = [
	["#base", AE3_power_base_device],
	["#type", "BaseGenerator"],
	[
		"#create", 
		{
			params ["_device_object"];

			_connector = createHashMapObject [AE3_power_connection_leaf, [_self]];
			_self set ["_connector", _connector];
		}
	],
	[
		"standby", {throw "NotSupportedError"}
	]

];