/**
 * Prints/outputs the string argument to stdout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if(count _options == 0) exitWith {[_computer, "Echo has too few options"] call AE3_armaos_fnc_shell_stdout;};

private _text = _options joinString " "; 

[_computer, _text] call AE3_armaos_fnc_shell_stdout;