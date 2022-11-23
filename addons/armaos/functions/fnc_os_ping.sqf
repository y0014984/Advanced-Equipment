/**
 * Pings a given address.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: IP-Address <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "ping";

if (count _options > 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooManyOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooFewOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _address = (_options select 0) splitString ".";

if (count _address != 4) exitWith { [_computer, localize "STR_AE3_ArmaOS_Exception_InvalidAddress"] call AE3_armaos_fnc_shell_stdout };

{
	_address set [_forEachIndex, parseNumber _x];
}forEach _address;

private _result = [_computer, _address, _computer] call AE3_network_fnc_ping;

if(isNull (_result select 0)) exitWith { [_computer, localize "STR_AE3_ArmaOS_Exception_PackageDropped"] call AE3_armaos_fnc_shell_stdout };

[ _computer, format [localize "STR_AE3_ArmaOS_Result_PingAnswer", _options select 0, round ((_result select 1)/1e5)] ] call AE3_armaos_fnc_shell_stdout;