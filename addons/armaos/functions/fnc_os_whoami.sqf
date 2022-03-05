/**
 * Returns the current user of the computer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Results:
 * 0: Current User <[STRING]>
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

[_terminal get "AE3_terminalLoginUser"];
