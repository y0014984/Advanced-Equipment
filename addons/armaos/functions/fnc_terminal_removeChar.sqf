/**
 * Removes the last character of the last line in the terminal buffer stored in the terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalPrompt = _terminal get "AE3_terminalPrompt";
private _terminalCursorPosition = _terminal get "AE3_terminalCursorPosition";

private _lastBufferLineIndex = (count _terminalBuffer) - 1;
private _lastBufferLine = _terminalBuffer # (_lastBufferLineIndex);

private _terminalMaxRows = 25;
private _terminalMaxColumns = 50;

if ((count _lastBufferLine) > (count _terminalPrompt)) then
{
	_terminalCursorPosition = _terminalCursorPosition - 1;
	_lastBufferLine = _lastBufferLine select [0, (count _lastBufferLine) - 1];
};

_terminalBuffer set [_lastBufferLineIndex, _lastBufferLine];

_terminal set ["AE3_terminalBuffer", _terminalBuffer];
_terminal set ["AE3_terminalCursorPosition", _terminalCursorPosition];