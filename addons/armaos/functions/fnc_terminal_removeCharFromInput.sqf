/**
 * Removes/deletes last character of current terminal input buffer of the given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";

forceUnicode 0;
_terminalInputBuffer set [0, (_terminalInputBuffer select 0) select [0, (count (_terminalInputBuffer select 0)) - 1]];

_terminal set ["AE3_terminalInputBuffer", _terminalInputBuffer];

_computer setVariable ["AE3_terminal", _terminal];