/*
 * Author: Root
 * Description: Sets the terminal input mode (SHELL, INPUT, LOGIN, PASSWORD, etc.).
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _mode <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _mode] call AE3_armaos_fnc_terminal_setInputMode;
 *
 * Public: No
 */
params['_computer', '_mode'];

private _terminal = _computer getVariable "AE3_terminal";
_terminal set ["AE3_terminalApplication", _mode];
_computer setVariable ["AE3_terminal", _terminal];
