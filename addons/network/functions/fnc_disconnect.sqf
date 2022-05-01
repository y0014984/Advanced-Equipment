/**
 * Disconnect a device from its parent router
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Parent router <OBJECT>
 * 
 * Returns:
 * None
 */

params['_entity', '_parent'];

_entity setVariable ['AE3_network_parent', objNull, true];

private _children = _parent getVariable 'AE3_network_children';
_parent setVariable ['AE3_network_children', _children - [_entity], true];

if(!isNil {_entity getVariable 'AE3_network_children'}) then
{
	[_entity] call AE3_network_fnc_dhcp_refresh;
};