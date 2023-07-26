/**
 * Get a ip from the heighest router in the hirarchy
 *
 * Arguments:
 * 0: Router <OBJECT>
 *
 * Returns:
 * 1: IP <[INT]>
 *
 */

params ["_entity"];

private _parent = _entity getVariable ["AE3_network_parent", objNull];

if (!alive _entity || _entity getVariable "AE3_power_powerState" == 0) exitWith { [127, 0, 0, 1] };

if (isNull _parent) then
{

	_counter = _entity getVariable "AE3_network_addressCounter";
	_counter = _counter + 1;
	_entity setVariable ["AE3_network_addressCounter", _counter, true];

	_address = _entity getVariable "AE3_network_address";
	_return = [0, 0, 0, 0];

	_return set [0, _address select 0];
	_return set [1, _address select 1];
	_return set [2, ((_address select 2) + floor (((_address select 2) + _counter)/255)) % 255];
	_return set [3, ((_address select 3) + _counter) % 255];

	_return;

}else
{
	[_parent] call AE3_network_fnc_dhcp_get;
};