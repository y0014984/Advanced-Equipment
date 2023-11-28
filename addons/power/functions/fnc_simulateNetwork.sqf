/**
 * Simulates a cycle of a network
 * 
 * Arguments:
 * 0: Network <HASHMAPOBJECT[Network]>
 *
 * Results:
 * If network has a positive power balance <BOOL>
 *
 */

params['_network'];

private _net_power = 0;

private _devices = _network get "devices";
{
	_device_power = _x call ["update_power"];
	_net_power = _net_power + _device_power;
}forEach _devices;


private _batteries = _network get "batteries";

if (_net_power == 0) exitWith {true};

private _sort_metric = "";
if (_net_power > 0) then
{
	_sort_metric = "get_effective_max_recharge_rate";
}else
{
	_sort_metric = "get_effective_max_discharge_rate";
};

private _sorted_batteries = [_batteries, [_sort_metric], {_x call [_input0]}, "ASCEND"] call BIS_fnc_sortBy;

private _batteries_left = count _sorted_batteries;
{
	_power = _net_power/_batteries_left;

	_real_power = _x call ["update_power", [_power]];

	_net_power = _net_power - _real_power;
	_batteries_left = _batteries_left - 1;
}forEach _sorted_batteries;


_net_power >= 0;