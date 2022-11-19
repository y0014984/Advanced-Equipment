/**
 * Clears the output buffer of a given terminal on a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith { [_computer, "'clear' has no options"] call AE3_armaos_fnc_shell_stdout; };

private _terminal = _computer getVariable "AE3_terminal";

_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];