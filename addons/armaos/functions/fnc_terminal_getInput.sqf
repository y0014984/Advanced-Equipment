/**
 * Returns the current content of the input buffer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";

(_terminalInputBuffer select 0) + (_terminalInputBuffer select 1);