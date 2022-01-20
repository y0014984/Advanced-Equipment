/**
 * Updates/sets the visable buffer variable in the terminal settings of a given computer by cropping the full terminal buffer to the visable size.
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
private _terminalMaxRows = _terminal get "AE3_terminalMaxRows";

private _terminalBufferLength = count _terminalBuffer;
private _lastBufferLineIndex = _terminalBufferLength - 1;

// + to preserve reference and force copy
private _terminalBufferVisable = +_terminalBuffer;

if (_terminalBufferLength > _terminalMaxRows) then
{
	_terminalBufferVisable = _terminalBufferVisable select [(_terminalBufferLength - _terminalMaxRows), _terminalMaxRows];
};

// ENHANCE: add block sign (needs new or modified font) instead of ¶ sign to the end of the _terminalBufferVisable

private _lastBufferVisableLineIndex = (count _terminalBufferVisable) - 1;
private _lastBufferVisableLine = _terminalBufferVisable # (_lastBufferVisableLineIndex);

_lastBufferVisableLine = _lastBufferVisableLine + "¶";

_terminalBufferVisable set [_lastBufferVisableLineIndex, _lastBufferVisableLine];

_terminal set ["AE3_terminalBufferVisable", _terminalBufferVisable];

_computer setVariable ["AE3_terminal", _terminal];