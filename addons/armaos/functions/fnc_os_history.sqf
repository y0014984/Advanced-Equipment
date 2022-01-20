/**
 * Lists/outputs the last commands of a given terminal on a given computer.
 * Also returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * 1: Informations/Commands <[STRING]>
 */

params ["_computer", "_options"];

_result = [];

if (count _options >= 1) exitWith {["   Command: history has no options"];};

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

private _numberedHistory = [];
{
	_numberedHistory pushBack (format ["%1: %2", (_forEachIndex + 1), _x]);
} forEach _terminalCommandHistory;

_result = ["   Command: history "] + [" "] + _numberedHistory;

_result;