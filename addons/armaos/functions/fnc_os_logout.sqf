/**
 * Logs out the current user, so users need to login again.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * 1: Informations <[STRING]>
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith {["   Command: logout has no options"];};

private _terminal = _computer getVariable "AE3_terminal";

_terminal deleteAt "AE3_terminalLoginUser";
_terminal deleteAt "AE3_terminalPasswordBuffer";

_terminal set ["AE3_terminalApplication", "LOGIN"];
_terminal set ["AE3_terminalPrompt", "LOGIN>"];
_terminal set ["AE3_terminalBuffer", []];
_terminal set ["AE3_terminalCursorLine", 0];
_terminal set ["AE3_terminalCursorPosition", 0];

[_computer] call AE3_armaos_fnc_terminal_addHeader;

private _result = [];

_result;