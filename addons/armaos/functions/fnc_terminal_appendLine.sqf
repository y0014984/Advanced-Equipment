/*
 * Author: Root
 * Description: Appends text to the last line in the terminal buffer.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _inputLine <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _inputLine] call AE3_armaos_fnc_terminal_appendLine;
 *
 * Public: No
 */

params ["_computer", "_inputLine"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalRenderedBuffer = _terminal get "AE3_terminalRenderedBuffer";

if (_inputLine isEqualType "") then
{
	_inputLine = [_inputLine];
};

private _index = (count _terminalBuffer) - 1;
(_terminalBuffer select _index) pushBack _inputLine;

private _render = [_computer, (_terminalBuffer select _index)] call AE3_armaos_fnc_terminal_renderLine;

_terminalRenderedBuffer set [_index, _render];
