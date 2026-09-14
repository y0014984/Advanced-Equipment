// File: fnc_dhcp_get.sqf
#include "..\script_component.hpp"
/**
 * Hands out a lease from a router's own subnet. Each router owns a single /24 and keeps its own
 * lease counter, so a device always receives an address inside the subnet of the router it is
 * connected to (the router's gateway address with an incrementing host octet). Routers are never
 * leased here; they keep the gateway address assigned during initialisation.
 *
 * Arguments:
 * 0: Router <OBJECT> - The router handing out the lease
 *
 * Returns:
 * 0: IP <[INT]>
 *
 */

params ["_entity"];

// A lease can only be handed out where the full device registry exists. This function returns the
// address, so it cannot route itself: every caller is server-side by construction and a hit here
// means a new client-side allocation path was introduced.
if (!isServer) exitWith
{
	WARNING_1("dhcp_get called on a client for %1 - addressing must run on the server",_entity);
	[127, 0, 0, 1]
};

if (isNull _entity || {!alive _entity} || {(_entity getVariable ["AE3_power_powerState", 0]) == 0}) exitWith { [127, 0, 0, 1] };

private _address = _entity getVariable ["AE3_network_address", [192, 168, 0, 1]];
private _counter = _entity getVariable ["AE3_network_addressCounter", 0];
private _lease = [127, 0, 0, 1];

for "_i" from 1 to 254 do
{
	_counter = (_counter + 1) % 255;
	if (_counter == 0) then { _counter = 1; };
	private _candidate = [
		_address select 0,
		_address select 1,
		_address select 2,
		((_address select 3) + _counter) % 256
	];
	if ((_candidate select 3) != (_address select 3) && {!([objNull, _candidate] call AE3_network_fnc_ipInUse)}) exitWith
	{
		_lease = _candidate;
	};
};

_entity setVariable ["AE3_network_addressCounter", _counter, true];
_lease
