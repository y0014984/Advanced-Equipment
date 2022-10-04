params ["_computer", "_options"];

if (count _options >= 1) exitWith {[_computer, "Shutdown has no options"] call AE3_armaos_fnc_shell_stdout;};

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalBuffer", []];

private _handle = [_computer, [false]] call (_computer getVariable "AE3_power_fnc_turnOffWrapper");