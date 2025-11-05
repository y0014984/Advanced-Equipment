/**
 * Adds multiple lines to the output buffer stored in terminal settings of a given computer.
 * Long lines will be split into multiple lines according to maximum allowed length of lines in the given terminal.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Command <[[STRING]]>
 *
 * Results:
 * None
 */

params ["_computer", "_outputLines"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalRenderedBuffer = _terminal get "AE3_terminalRenderedBuffer";

if (_outputLines isEqualType "") then
{
	_outputLines = [_outputLines];
};

{
	_terminalRenderedBuffer pushBack ([_computer, _x] call AE3_armaos_fnc_terminal_renderLine);

	if (_x isEqualType "") then
	{
		_terminalBuffer pushBack [_x];
	}else
	{
		_terminalBuffer pushBack _x;
	};

}forEach _outputLines;

private _terminalCursorPosition = 0;
_terminal set ["AE3_terminalBuffer", _terminalBuffer];
//_terminal set ["AE3_terminalCursorLine", _terminalCursorLine];
_terminal set ["AE3_terminalCursorPosition", _terminalCursorPosition];

_computer setVariable ["AE3_terminal", _terminal];
