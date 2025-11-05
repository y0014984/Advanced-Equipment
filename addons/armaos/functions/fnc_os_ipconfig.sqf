/**
 * Pings a given ip address in the current network.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: IP-Address <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = [];
private _commandSyntax =
[
	[
			["command", _commandName, true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _unused_ae3OptsThings = [];
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _address = _computer getVariable "AE3_network_address";

if(isNil "_address") exitWith { [ _computer, localize "STR_AE3_ArmaOS_Exception_NoAddressDevice" ] call AE3_armaos_fnc_shell_stdout; };

[_computer, format [localize "STR_AE3_ArmaOS_Result_IPv4Address", [_address] call AE3_network_fnc_ip2str]] call AE3_armaos_fnc_shell_stdout;
