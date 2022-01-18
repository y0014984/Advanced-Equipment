params ["_computer", "_options"];

if (count _options >= 1) exitWith {["   Command: shutdown has no options"];};

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalBuffer", []];
_computer setVariable ["AE3_terminal", _terminal];

private _handle = [_computer, false] spawn AE3_armaos_fnc_turnOffComputerAction;

private _result = ["   Command: shutdown"];

_result;