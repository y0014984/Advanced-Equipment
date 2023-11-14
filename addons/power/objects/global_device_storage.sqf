AE3_power_global_device_storage = [
	["#flags", ["sealed"]],

	// Class Variable
	["_devices", []],

	[
		"#create", {}
	],
	[
		"add_device", 
	{
		params["_device"];
		(_self get "_devices") pushBackUnique _device;
	}
	],
	[
		"get_devices",
		{
			(_self get "_devices");
		}
	]
];