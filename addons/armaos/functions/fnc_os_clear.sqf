/**
 * Clears the output buffer of a given terminal on a given computer.
 * Also returns information about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * 1: Information <[STRING]>
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith {["Clear has no options"];};

private _terminal = _computer getVariable "AE3_terminal";

_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];

"";