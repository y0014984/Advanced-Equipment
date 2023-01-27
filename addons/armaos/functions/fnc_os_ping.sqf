/**
 * Pings a given address.
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
			["command", _commandName, true, false],
			["path", "IP-ADDRESS", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _address = (_ae3OptsThings select 0) splitString ".";

if (count _address != 4) exitWith { [_computer, localize "STR_AE3_ArmaOS_Exception_InvalidAddress"] call AE3_armaos_fnc_shell_stdout };

{
	_address set [_forEachIndex, parseNumber _x];
}forEach _address;

private _result = [_computer, _address, _computer] call AE3_network_fnc_ping;

if(isNull (_result select 0)) exitWith { [_computer, localize "STR_AE3_ArmaOS_Exception_PackageDropped"] call AE3_armaos_fnc_shell_stdout };

[ _computer, format [localize "STR_AE3_ArmaOS_Result_PingAnswer", _ae3OptsThings select 0, round ((_result select 1)/1e5)] ] call AE3_armaos_fnc_shell_stdout;