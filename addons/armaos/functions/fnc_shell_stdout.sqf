/*
 * Author: Root
 * Description: Writes output to the terminal display. Accepts string or array of strings/formatted text. This is the standard output function for all commands.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _input <STRING or ARRAY> - The text to output
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "Hello World"] call AE3_armaos_fnc_shell_stdout;
 *
 * Public: Yes
 */
params['_computer', '_input'];

if (!(_input isEqualType [])) then
{
	_input = [_input];
};

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _input] call AE3_armaos_fnc_terminal_addLines;
[_computer, _terminal get "AE3_terminalOutput"] call AE3_armaos_fnc_terminal_updateOutput;
