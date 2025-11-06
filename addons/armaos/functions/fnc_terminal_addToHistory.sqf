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

// Get the user's command history array
private _userCommandHistory = _terminalCommandHistory getOrDefault [_username, []];

// Add the command to the user's history
_userCommandHistory pushBack _commandString;

// Set the modified array back into the hashmap
_terminalCommandHistory set [_username, _userCommandHistory];

_computer setVariable ["AE3_terminal", _terminal];
