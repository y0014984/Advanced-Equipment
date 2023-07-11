/**
 * Connect a router to another router.
 *
 * Arguments:
 * 0: Router to connect <OBJECT>
 * 1: Parent router <OBJECT>
 *
 * Returns:
 * None
 */

params ["_router", "_parent"];

if (!isNull (_router getVariable ["AE3_network_parent", objNull])) then
{
	[_router] call AE3_network_fnc_disconnect;
};

_router setVariable ["AE3_network_parent", _parent, true];

private _children = _parent getVariable ["AE3_network_children", []];
_parent setVariable ["AE3_network_children", _children + [_router], true];

if ([_parent, _parent] call AE3_network_fnc_connect_isCyclic) exitWith
{
	_router setVariable ["AE3_network_parent", objNull, true];

	_children = _parent getVariable ["AE3_network_children", []];
	_parent setVariable ["AE3_network_children", _children - [_router], true];
};

_router setVariable ["AE3_network_address", [_router] call AE3_network_fnc_dhcp_get, true];

if (count (_router getVariable ["AE3_network_children", []]) != 0) then
{
	[_router] call AE3_network_fnc_dhcp_refresh;
};

[_router, "networkConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
[_parent, "networkConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
