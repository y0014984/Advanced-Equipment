/**
 * Sets the input mode of the terminal.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Mode <STRING>
 *
 * Results:
 * None
 */
params['_computer', '_mode'];

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalApplication", _mode];
_computer setVariable ["AE3_terminal", _terminal];
