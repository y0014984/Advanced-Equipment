/**
 * Lists/outputs the last commands of a given terminal on a given computer.
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

private _commandOpts =
[
		["_clear", "c", "", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_History_clear"],
        ["_deleteAtOffset", "d", "", "number", -1, false, localize "STR_AE3_ArmaOS_CommandHelp_History_deleteAtOffset"]
];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _terminal = _computer getVariable "AE3_terminal";

private _username = _terminal get "AE3_terminalLoginUser";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

private _terminalCommandHistoryUser = _terminalCommandHistory get _username;

if (_clear) exitWith
{
	_terminalCommandHistoryUser = [];
  _terminalCommandHistory set [_username, _terminalCommandHistoryUser];
	_terminal set ["AE3_terminalCommandHistory", _terminalCommandHistory];

	[_computer, localize "STR_AE3_ArmaOS_Result_HistoryCleared"] call AE3_armaos_fnc_shell_stdout;
};

if ((_deleteAtOffset != -1) && (_deleteAtOffset != 0) && !(_deleteAtOffset > (count _terminalCommandHistoryUser))) exitWith
{
	_terminalCommandHistoryUser deleteAt (_deleteAtOffset - 1);
  _terminalCommandHistory set [_username, _terminalCommandHistoryUser];
	_terminal set ["AE3_terminalCommandHistory", _terminalCommandHistory];

	[_computer, format [localize "STR_AE3_ArmaOS_Result_HistoryElementDeleted", _deleteAtOffset]] call AE3_armaos_fnc_shell_stdout;
};

private _numberedHistory = [];
{
	_numberedHistory pushBack (format ["%1: %2", (_forEachIndex + 1), _x]);
} forEach _terminalCommandHistoryUser;

[_computer, _numberedHistory] call AE3_armaos_fnc_shell_stdout;