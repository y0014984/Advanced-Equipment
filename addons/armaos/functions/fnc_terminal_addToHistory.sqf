/**
 * Adds the given command string to the command history variable in the terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_commandString"];

private _terminal = _computer getVariable "AE3_terminal";

private _username = _terminal get "AE3_terminalLoginUser";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";

_terminalCommandHistory = _terminalCommandHistory get _username;

_terminalCommandHistory pushBack _commandString;

_computer setVariable ["AE3_terminal", _terminal];
