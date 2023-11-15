AE3_power_battery_state = [
	["#flags", ["sealed"]],
	["capacity", 0],
	["charge", 0],

	[
		"#create",
		{
			params ["_capacity", "_charge"];

			_self set ["capacity", _capacity];
			_self set ["charge", _charge];
		}
	],
	[
		"get_capacity_left",
		{
			(_self get "capacity") - (_self get "charge");
		}
	]
];