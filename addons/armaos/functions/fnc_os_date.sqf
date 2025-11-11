/*
 * Author: Root
 * Description: Displays the current in-game date and time. Similar to Unix date command.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command options and arguments
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, [], "date"] call AE3_armaos_fnc_os_date;
 *
 * Public: Yes
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

private _date = date;
private _year = _date select 0;
private _month = _date select 1;
private _day = _date select 2;

if (_month < 10) then {_month = format["0%1", _month]};
if (_day < 10) then {_day = format["0%1", _day]};

private _time = [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString; // 07:21:12

_date = format [localize "STR_AE3_ArmaOS_Result_Date", _year, _month, _day, _time];

[_computer, _date] call AE3_armaos_fnc_shell_stdout;
