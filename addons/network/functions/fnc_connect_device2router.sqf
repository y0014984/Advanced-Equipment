// File: fnc_connect_device2router.sqf
/**
 * Connect a device to a router.
 *
 * Arguments:
 * 0: Device to connect <OBJECT>
 * 1: Parent router <OBJECT>
 *
 * Returns:
 * None
 */

params ["_device", "_parent"];

if (isNull _device) exitWith {};

// Addressing must be decided by the server: only it holds the complete device registry needed to
// detect a duplicate address. Hand the request over rather than leasing from a client's partial view.
if (!isServer) exitWith
{
	["ae3_network_connectDevice", [netId _device, netId _parent]] call CBA_fnc_serverEvent;
};

// A device belongs to exactly one router: drop any existing uplink before joining the new one so it
// cannot linger in a previous router's children list.
private _currentParent = _device getVariable ["AE3_network_parent", objNull];
if (!isNull _currentParent && _currentParent isNotEqualTo _parent) then
{
	[_device] call AE3_network_fnc_disconnect;
};

private _children = _parent getVariable ["AE3_network_children", []];
_parent setVariable ["AE3_network_children", _children + [_device], true];

_device setVariable ["AE3_network_parent", _parent, true];
if (isNull _parent) then
{
	_device setVariable ["AE3_network_address", [127, 0, 0, 1], true];
}
else
{
	// Static leases are per router. Joining a different router falls back to DHCP unless this laptop
	// has a saved static address for that router. The 3DEN default static is only reused when it sits
	// inside the new gateway's subnet, so switching networks never carries an out-of-subnet address
	// across - an unrelated gateway hands out a fresh DHCP lease instead.
	private _leases = _device getVariable ["AE3_network_staticIpByRouter", createHashMap];
	private _staticStr = _leases getOrDefault [netId _parent, ""];
	private _static = [_staticStr] call AE3_network_fnc_str2ip;
	if (_static isEqualTo []) then
	{
		private _defStr = _device getVariable ["AE3_network_staticIpDefault", ""];
		private _def = [_defStr] call AE3_network_fnc_str2ip;
		private _gateway = _parent getVariable ["AE3_network_address", []];
		if ([_def, _gateway] call AE3_network_fnc_ipInSubnet) then
		{
			_staticStr = _defStr;
			_static = _def;
		};
	};
	if (_static isNotEqualTo [] && {!([_device, _static] call AE3_network_fnc_ipInUse)}) then
	{
		_device setVariable ["AE3_network_staticIp", _staticStr, true];
		_device setVariable ["AE3_network_address", _static, true];
	}
	else
	{
		_device setVariable ["AE3_network_staticIp", "", true];
		_device setVariable ["AE3_network_address", [_parent] call AE3_network_fnc_dhcp_get, true];
	};
};

if (isNull _parent) then
{
    [_device, "networkConnected", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
}
else
{
    [_device, "networkConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
    [_parent, "networkConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
};
