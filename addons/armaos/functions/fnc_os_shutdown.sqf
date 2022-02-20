params ["_computer", "_options"];

if (count _options >= 1) exitWith {["Shutdown has no options"];};

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalBuffer", []];

private _handle = [_computer, [false]] call (_computer getVariable "AE3_power_fnc_turnOffWrapper");

private _result = [""];

_result;