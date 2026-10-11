// File: fnc_shell_stdin.sqf
/*
 * Author: Root, Wasserstoff
 * Description: Gets user input from the terminal. Waits for user to enter text and press enter, then returns the input string.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 *
 * Return Value:
 * User input text <STRING>
 *
 * Example:
 * private _input = [_computer] call AE3_armaos_fnc_shell_stdin;
 *
 * Public: Yes
 */

params['_computer'];

// Inside an SSH session the keyboard belongs to the operator's terminal on the source computer, so
// the prompt is read there instead of from the target's minimal session terminal.
private _source = [_computer] call AE3_armaos_fnc_shell_getSshSource;
if (!isNull _source) then { _computer = _source; };


[_computer, "INPUT"] call AE3_armaos_fnc_terminal_setInputMode;

private _terminal = _computer getVariable "AE3_terminal";

waitUntil
{
	(_terminal get "AE3_terminalApplication") isEqualTo "";
};

private _result = [_computer] call AE3_armaos_fnc_terminal_getInput;
_terminal deleteAt "AE3_terminalInputBuffer";

_result;
