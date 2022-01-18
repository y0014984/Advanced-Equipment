params ["_computer", "_options"];

private _result = [];

if (count _options >= 1) exitWith {["   Command: clear has no options"];};

private _terminal = _computer getVariable "AE3_terminal";

_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];

_computer setVariable ["AE3_terminal", _terminal];

_result = [];

_result;