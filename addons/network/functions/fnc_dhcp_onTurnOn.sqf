/**
 * Updates ip adress on turn on.
 * 
 * Arguments:
 * 0: Device <OBJECT>
 *
 * Returns:
 * None
 */

params ["_entity"];

private _parent = _entity getVariable ["AE3_network_parent", objNull];

if (!isNull _parent) then
{
	_ip = [_parent] call AE3_network_fnc_dhcp_get;
	_entity setVariable ["AE3_network_address", _ip, true];
};

if (!isNil {_entity getVariable "AE3_network_children"}) then
{
	/*
	 Sketchy workaround, because this is executed before the
	 power is turned on, which is requiered for the dhcp get request
	 to work.

	 TODO: Improve
	*/
	[_entity] spawn
	{
		sleep 1;
		_this call AE3_network_fnc_dhcp_refresh;
	};
};
