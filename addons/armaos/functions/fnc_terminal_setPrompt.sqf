/**
 * Uses the active prompt, stored in the prompt variable to change the last line of the terminal buffer accordingly, 
 * all stored in the terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalCursorPosition = _terminal get "AE3_terminalCursorPosition";
private _terminalPrompt = _terminal get "AE3_terminalPrompt";

[_computer, [[_terminalPrompt]]] call AE3_armaos_fnc_terminal_addLines;
