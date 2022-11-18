/**
 * Lists/outputs the last commands of a given terminal on a given computer.
 * Also returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "history";

if (count _options >= 1) exitWith {[_computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasNoOptions", _commandName]] call AE3_armaos_fnc_shell_stdout;};

private _terminal = _computer getVariable "AE3_terminal";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

private _numberedHistory = [];
{
	_numberedHistory pushBack (format ["%1: %2", (_forEachIndex + 1), _x]);
} forEach _terminalCommandHistory;

[_computer, _numberedHistory] call AE3_armaos_fnc_shell_stdout;