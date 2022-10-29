/**
 * Lists/outputs the last commands of a given terminal on a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith { [_computer, "'history' has no options"] call AE3_armaos_fnc_shell_stdout; };

private _terminal = _computer getVariable "AE3_terminal";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

private _numberedHistory = [];
{
	_numberedHistory pushBack (format ["%1: %2", (_forEachIndex + 1), _x]);
} forEach _terminalCommandHistory;

[_computer, _numberedHistory] call AE3_armaos_fnc_shell_stdout;