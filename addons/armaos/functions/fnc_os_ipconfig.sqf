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

if (count _options >= 1) exitWith { [_computer, "'ipconfig' has no options"] call AE3_armaos_fnc_shell_stdout; };

private _address = _computer getVariable 'AE3_network_address';

if(isNil "_address") exitWith {[_computer, "No addressdevice attached."] call AE3_armaos_fnc_shell_stdout};

[_computer, format ["IPv4 Adress: %1", [_address] call AE3_network_fnc_ip2str]] call AE3_armaos_fnc_shell_stdout;