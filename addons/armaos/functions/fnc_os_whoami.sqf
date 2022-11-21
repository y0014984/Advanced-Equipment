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

private _commandName = "whoami";

if (count _options >= 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasNoOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _terminal get "AE3_terminalLoginUser"] call AE3_armaos_fnc_shell_stdout;
