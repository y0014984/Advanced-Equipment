params ["_computer", "_options"];

if (count _options >= 1) exitWith {["   Command: shutdown has no options"];};

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalBuffer", []];

private _handle = [_computer, false] spawn AE3_armaos_fnc_computer_addActionTurnOff;

private _result = ["   Command: shutdown"];

_result;