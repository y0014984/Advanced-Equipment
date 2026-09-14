// File: fnc_ipInUse.sqf
/*
 * Author: Root
 * Description: Checks whether an address is already taken, either by another initialized laptop or
 * by a router's own gateway address. Handing a laptop the address of its gateway would make the two
 * indistinguishable to route resolution, so gateways count as taken.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device requesting the address
 * 1: _ip <ARRAY> - Candidate address
 *
 * Return Value:
 * In use <BOOL>
 */

params ["_device", "_ip"];

private _computers = missionNamespace getVariable ["ae3_desktop_computers", []];
private _taken = (_computers findIf {
	!isNull _x
	&& _x isNotEqualTo _device
	&& {_x getVariable ["AE3_cap_hasTerminal", false]}
	&& {(_x getVariable ["AE3_network_address", [127, 0, 0, 1]]) isEqualTo _ip}
}) >= 0;

if (_taken) exitWith { true };

// The registry can hold dead or deleted routers; those are skipped rather than treated as owners.
private _routers = missionNamespace getVariable ["AE3_network_routers", []];
(_routers findIf {
	!isNull _x
	&& _x isNotEqualTo _device
	&& {(_x getVariable ["AE3_network_address", []]) isEqualTo _ip}
}) >= 0
