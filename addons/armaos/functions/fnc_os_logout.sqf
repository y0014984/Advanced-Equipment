/**
 * Logs out the current user, so users need to login again.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith {[_computer, "Logout has no options"] call AE3_armaos_fnc_shell_stdout;};

private _terminal = _computer getVariable "AE3_terminal";

_terminal deleteAt "AE3_terminalLoginUser";
_terminal deleteAt "AE3_terminalInputBuffer";

_terminal set ["AE3_terminalApplication", "LOGIN"];
_terminal set ["AE3_terminalPrompt", "LOGIN>"];
_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];

[_computer] call AE3_armaos_fnc_terminal_addHeader;