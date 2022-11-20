/**
 * Returns the current user of the computer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith { [_computer, "'whoami' has no options"] call AE3_armaos_fnc_shell_stdout; };

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _terminal get "AE3_terminalLoginUser"] call AE3_armaos_fnc_shell_stdout;
