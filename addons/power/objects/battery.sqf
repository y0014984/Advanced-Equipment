AE3_power_battery = [
	["#base", AE3_power_base_device],
	["#type", "Battery"],

	["_battery_state", objNull],
	["_max_charge_rate", 0],
	[
		"#create", 
		{
			params ["_device_object", "_capacity", "_base_charge", "_max_charge_rate"];

			_battery_state = createHashMapObject [AE3_power_battery_state, [_capacity, _base_charge]];

			_self set ["_battery_state", _battery_state];
			_self set ["_charge_rate", _max_charge_rate];
		}
	],
	[
		"standby", {throw "NotSupportedError"}
	],
	[	
		"_calcPower",
		{
			params["_input_power"];

			_power_state = _self get "_power_state";

			if (_power_state == 0) exitWith {0};

			if (_input_power >= 0) then
			{
				_effective_charge_rate = _self call ["get_effective_max_recharge_rate"];
				_power = _effective_charge_rate min _input_power;
			}else
			{
				_effective_discharge_rate = _self call ["get_effective_max_discharge_rate"];
				_power = -_effective_discharge_rate max _input_power;
			};

			_battery_state = _self get "_battery_state";
			_new_charge = (_battery_state get "charge" + _power);
			_battery_state set ["charge", _new_charge];

			_power;
		}
	],
	[
		"_rate_clip_power",
		{
			params ["_power"];
			_input_power_sign = (abs _power)/_power;
			
			_input_power_sign * ((abs _power) min (_self get "_max_charge_rate"));
		}
	],
	[
		"get_effective_max_recharge_rate",
		{
			_battery_state = _self get "_battery_state";
			_charge = _battery_state get "_charge";
			_self call ["_rate_clipped_input_power", [_charge]];
		}
	],
	[
		"get_effective_max_discharge_rate",
		{
			_battery_state = _self get "_battery_state";
			_capacity_left = _battery_state call ["get_capacity_left"];
			_self call ["_rate_clipped_input_power", [_capacity_left]];
		}
	]
];