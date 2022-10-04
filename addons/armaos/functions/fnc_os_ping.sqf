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

params ["_computer", "_options"];

if (count _options > 1) exitWith {[_computer, "Too many options"] call AE3_armaos_fnc_shell_stdout};
if (count _options < 1) exitWith {[_computer, "Too few options"] call AE3_armaos_fnc_shell_stdout};

private _address = (_options select 0) splitString ".";

if (count _address != 4) exitWith {[_computer, "Invalid address!"] call AE3_armaos_fnc_shell_stdout};

{
	_address set [_forEachIndex, parseNumber _x];
}forEach _address;

private _result = [_computer, _address, _computer] call AE3_network_fnc_ping;

if(isNull (_result select 0)) exitWith {[_computer, "Package dropped."] call AE3_armaos_fnc_shell_stdout};

[_computer, format ["Answer from %1: Time:%2 ms", _options select 0, round ((_result select 1)/1e5)]] call AE3_armaos_fnc_shell_stdout;