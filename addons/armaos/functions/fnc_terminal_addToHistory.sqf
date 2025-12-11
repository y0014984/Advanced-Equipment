/*
 * Author: Root
 * Description: Adds a command to the current user's command history for later recall with arrow keys or history command.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _commandString <STRING> - The command to add to history
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "ls -l"] call AE3_armaos_fnc_terminal_addToHistory;
 *
 * Public: Yes
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
