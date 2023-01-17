/**
 * Prints/outputs the ingame date and time on a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
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

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _date = date;
private _year = _date select 0;
private _month = _date select 1;
private _day = _date select 2;

if (_month < 10) then {_month = format["0%1", _month]};
if (_day < 10) then {_day = format["0%1", _day]};

private _time = [daytime, "HH:MM:SS"] call BIS_fnc_timeToString; // 07:21:12

_date = format [localize "STR_AE3_ArmaOS_Result_Date", _year, _month, _day, _time];

[_computer, _date] call AE3_armaos_fnc_shell_stdout;