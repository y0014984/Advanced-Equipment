/**
 * Removes/deletes last character of a hidden password variable in terminal settings of the given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalPasswordBuffer = _terminal get "AE3_terminalPasswordBuffer";

_terminalPasswordBuffer = _terminalPasswordBuffer select [0, (count _terminalPasswordBuffer) - 1];

_terminal set ["AE3_terminalPasswordBuffer", _terminalPasswordBuffer];