/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Updates the terminal prompt line (command input line) with the current prompt text. Typically shows username, hostname, and current directory.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_setPrompt;
 *
 * Public: Yes
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalCursorPosition = _terminal get "AE3_terminalCursorPosition";
private _terminalPrompt = _terminal get "AE3_terminalPrompt";

[_computer, [[_terminalPrompt]]] call AE3_armaos_fnc_terminal_addLines;
