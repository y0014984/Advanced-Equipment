/**
 * Returns the current user of the computer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _terminal get "AE3_terminalLoginUser"] call AE3_armaos_fnc_shell_stdout;
