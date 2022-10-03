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

params ["_computer", "_options"];

if (count _options > 1) exitWith {["Too many options"]};
if (count _options < 1) exitWith {["Too few options"]};

private _address = (_options select 0) splitString ".";

if (count _address != 4) exitWith {["Invalid address!"]};

{
	_address set [_forEachIndex, parseNumber _x];
}forEach _address;

private _result = [_computer, _address, _computer] call AE3_network_fnc_ping;

hint str _result;

if(isNull (_result select 0)) exitWith {["Package dropped."]};

[format ["Answer from %1: Time:%2 ms", _options select 0, round ((_result select 1)/1e5)]];