/**
 * Appends line to last line.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Line <STRING> or <[STRING]> or <[STRING, STRING]>
 *
 * Returns:
 * None
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