/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Adds one or more lines of output to the terminal buffer. Accepts string or array of strings/formatted text. Long lines are automatically wrapped to terminal width.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _outputLines <STRING or ARRAY> - Lines to add to terminal output
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["Line 1", "Line 2"]] call AE3_armaos_fnc_terminal_addLines;
 *
 * Public: Yes
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
