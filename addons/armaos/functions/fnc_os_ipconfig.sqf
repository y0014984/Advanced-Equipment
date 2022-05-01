/**
 * Pings a given address.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Address <[STRING]>
 *
 * Results:
 * 1: Informations <[STRING]>
 */

params ["_computer"];

private _address = _computer getVariable 'AE3_network_address';

if(isNil "_address") exitWith {["No addressdevice attached."]};

[format ["IPv4 Adress: %1", [_address] call AE3_network_fnc_ip2str]];