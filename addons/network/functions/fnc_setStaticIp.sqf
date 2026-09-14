// File: fnc_setStaticIp.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Applies a laptop static IP after validating format and duplicate use. Static leases
 * are stored per connected router, so switching networks falls back to DHCP unless that router has
 * its own configured lease.
 *
 * Arguments:
 * 0: _device <OBJECT>
 * 1: _ipStr <STRING> - Empty string clears the current network's static lease
 *
 * Return Value:
 * Result <HASHMAP>
 */

params ["_device", ["_ipStr", ""]];

private _res = createHashMapFromArray [["error", ""]];

// Duplicate detection needs the full device registry, which only the server holds. This function
// returns its result, so it cannot route itself: callers reach it through the desktop and Zeus
// server events, and a hit here means a new client-side path was introduced.
if (!isServer) exitWith
{
	WARNING_1("setStaticIp called on a client for %1 - addressing must run on the server",_device);
	_res set ["error", "not_server"];
	_res
};

if (isNull _device) exitWith { _res set ["error", "no_device"]; _res };

private _parent = _device getVariable ["AE3_network_parent", objNull];
private _parentKey = if (isNull _parent) then { "" } else { netId _parent };
private _leases = _device getVariable ["AE3_network_staticIpByRouter", createHashMap];

if (_ipStr isEqualTo "") exitWith
{
	if (_parentKey isNotEqualTo "") then { _leases deleteAt _parentKey; };
	_device setVariable ["AE3_network_staticIpByRouter", _leases, true];
	_device setVariable ["AE3_network_staticIp", "", true];
	if (!isNull _parent) then
	{
		_device setVariable ["AE3_network_address", [_parent] call AE3_network_fnc_dhcp_get, true];
	};
	_res set ["ok", true];
	_res set ["ip", [_device getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str];
	// Nudge any open desktop System panel to re-read the address live.
	["ae3_desktop_sysChanged", []] call CBA_fnc_globalEvent;
	_res
};

private _ip = [_ipStr] call AE3_network_fnc_str2ip;
if (_ip isEqualTo []) exitWith { _res set ["error", "bad_ip"]; _res };
if ([_device, _ip] call AE3_network_fnc_ipInUse) exitWith { _res set ["error", "ip_in_use"]; _res };

if (_parentKey isNotEqualTo "") then
{
	_leases set [_parentKey, _ipStr];
	_device setVariable ["AE3_network_staticIpByRouter", _leases, true];
};

_device setVariable ["AE3_network_staticIp", _ipStr, true];
_device setVariable ["AE3_network_address", _ip, true];

// Nudge any open desktop System panel to re-read the address live.
["ae3_desktop_sysChanged", []] call CBA_fnc_globalEvent;

_res set ["ok", true];
_res set ["ip", _ipStr];
_res
