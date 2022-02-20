params ["_computer", "_options"];

if (count _options >= 1) exitWith {["Standby has no options"];};

private _handle = [_computer] spawn (_computer getVariable "AE3_power_fnc_standbyWrapper");

private _result = [""];

_result;