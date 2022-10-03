/**
 * Refreshes the ip address for all network devices and router below
 * the given router.
 *
 * Arguments:
 * 0: Router <OBJECT>
 * 
 * Returns:
 * None
 *
 */

 params['_entity'];

{

	_x setVariable ['AE3_network_address', [_entity] call AE3_network_fnc_dhcp_get, true];

	if(!isNil {_x getVariable 'AE3_network_childern'}) then
	{
		[_x] call AE3_network_fnc_dhcp_refresh;
	};

} forEach (_entity getVariable 'AE3_network_children');