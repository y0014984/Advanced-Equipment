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