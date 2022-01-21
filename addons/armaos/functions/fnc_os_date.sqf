/**
 * Prints/outputs the ingame date and time on a given computer.
 * Also returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * 1: Informations/Date and Time <[STRING]>
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith {["   Command: date has no options"];};

private _date = date;
private _year = _date select 0;
private _month = _date select 1;
private _day = _date select 2;

if (_month < 10) then {_month = format["0%1", _month]};
if (_day < 10) then {_day = format["0%1", _day]};

private _time = [daytime, "HH:MM:SS"] call BIS_fnc_timeToString; // 07:21:12

_date = format ["Date: %1-%2-%3 %4", _year, _month, _day, _time];

private _result = ["   Command: date "] + [" "] + [_date];

_result;