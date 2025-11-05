/**
 * Adds a single character to the output buffer stored in the terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Character <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_inputChar"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalCursorPosition = _terminal get "AE3_terminalCursorPosition";
private _terminalMaxColumns = _terminal get "AE3_terminalMaxColumns";

private _lastBufferLineIndex = (count _terminalBuffer) - 1;
private _lastBufferLine = "";

if (_lastBufferLineIndex >= -1) then 
{
	_lastBufferLine = _terminalBuffer select _lastBufferLineIndex;
};

_terminalCursorPosition = _terminalCursorPosition + 1;

if ((count _lastBufferLine) < _terminalMaxColumns) then
{
	_lastBufferLine = _lastBufferLine + _inputChar;
};

if (_lastBufferLineIndex == -1) then { _lastBufferLineIndex = 0; };

_terminalBuffer set [_lastBufferLineIndex, _lastBufferLine];

_terminal set ["AE3_terminalBuffer", _terminalBuffer];
_terminal set ["AE3_terminalCursorPosition", _terminalCursorPosition];

_computer setVariable ["AE3_terminal", _terminal];
