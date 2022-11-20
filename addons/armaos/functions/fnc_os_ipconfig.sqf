/**
 * Pings a given ip address in the current network.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: IP-Address <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "ipconfig";

if (count _options >= 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasNoOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _address = _computer getVariable 'AE3_network_address';

if(isNil "_address") exitWith { [ _computer, localize "STR_AE3_ArmaOS_Exception_NoAddressDevice" ] call AE3_armaos_fnc_shell_stdout; };

[_computer, format [localize "STR_AE3_ArmaOS_Result_IPv4Address", [_address] call AE3_network_fnc_ip2str]] call AE3_armaos_fnc_shell_stdout;