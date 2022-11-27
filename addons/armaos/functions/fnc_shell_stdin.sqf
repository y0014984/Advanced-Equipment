/**
 * Gets user input from the terminal.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * User Input <STRING>
 */

params['_computer'];


[_computer, "INPUT"] call AE3_armaos_fnc_terminal_setInputMode;

private _terminal = _computer getVariable "AE3_terminal";

waitUntil
{
	(_terminal get "AE3_terminalApplication") isEqualTo "";
};

private _result = [_computer] call AE3_armaos_fnc_terminal_getInput;
_terminal deleteAt "AE3_terminalInputBuffer";

_result;