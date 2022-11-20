/**
 * Prints/outputs the string argument to stdout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: String <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "echo";

if (count _options == 0) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooFewOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _text = _options joinString " "; 

[_computer, _text] call AE3_armaos_fnc_shell_stdout;