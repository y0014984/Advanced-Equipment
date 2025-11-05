/**
 * Writes input to terminal.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Input <STRING>
 *
 * Results:
 * None
 */
params['_computer', '_input'];

if (!(_input isEqualType [])) then
{
	_input = [_input];
};

private _terminal = _computer getVariable "AE3_terminal";

[_computer, _input] call AE3_armaos_fnc_terminal_addLines;
[_computer, _terminal get "AE3_terminalOutput"] call AE3_armaos_fnc_terminal_updateOutput;
