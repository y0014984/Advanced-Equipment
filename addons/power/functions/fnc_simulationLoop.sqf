


private _global_device_storage = createHashMapObject [AE3_power_global_device_storage];
private _devices = _global_device_storage call ["get_devices"];

private _network_builder = createHashMapObject [AE3_power_network_builder];
_network_builder call ["build", [_devices]];

private _networks = _network_builder call ["get_networks"];

{
	_valid = [_x] call AE3_power_fnc_simulateNetwork;

}forEach _networks;