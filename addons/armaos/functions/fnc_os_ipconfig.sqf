/**
 * Pings a given address.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Address <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer"];

private _address = _computer getVariable 'AE3_network_address';

if(isNil "_address") exitWith {[_computer, localize "STR_AE3_ArmaOS_Exception_NoAddressDevice"] call AE3_armaos_fnc_shell_stdout};

[_computer, format [localize "STR_AE3_ArmaOS_Result_IPv4Address", [_address] call AE3_network_fnc_ip2str]] call AE3_armaos_fnc_shell_stdout;