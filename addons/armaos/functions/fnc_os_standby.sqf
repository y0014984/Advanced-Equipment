params ["_computer", "_options"];

if (count _options >= 1) exitWith {[_computer, "Standby has no options"] call AE3_armaos_fnc_shell_stdout;};

private _handle = [_computer] spawn (_computer getVariable "AE3_power_fnc_standbyWrapper");

private _result = [""];

_result;