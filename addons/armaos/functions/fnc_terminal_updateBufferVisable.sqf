/**
 * Updates/sets the visable buffer variable in the terminal settings of a given computer by cropping
 * the full terminal buffer to the visable size with respect of eventually scrolling position changes.
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
private _terminalApplication = _terminal get "AE3_terminalApplication";

private _terminalInputBuffer = ["", ""];

if (!isNil { _terminal get "AE3_terminalInputBuffer" }) then 
{
	_terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";
};

private _terminalScrollPosition = _terminal get "AE3_terminalScrollPosition";

private _terminalBufferLength = count _terminalBuffer;
private _lastBufferLineIndex = _terminalBufferLength - 1;

// + to preserve reference and force copy
private _terminalBufferVisable = +_terminalBuffer;

// ENHANCEMENT: add block sign (needs new or modified font) instead of ¶ sign to the end of the _terminalBufferVisable
private _lastBufferVisableLineIndex = (count _terminalBufferVisable) - 1;
private _lastBufferVisableLine = _terminalBufferVisable # (_lastBufferVisableLineIndex);

if (_terminalApplication isEqualTo "PASSWORD") then
{
	_lastBufferVisableLine = _lastBufferVisableLine + ((_terminalInputBuffer select 0) regexReplace [".", "*"]) + "¶" + ((_terminalInputBuffer select 1) regexReplace [".", "*"]);
}else
{
	_lastBufferVisableLine = _lastBufferVisableLine + (_terminalInputBuffer select 0) + "¶" + (_terminalInputBuffer select 1);
};

_terminalBufferVisable set [_lastBufferVisableLineIndex, _lastBufferVisableLine];

if (_terminalScrollPosition > (_terminalBufferLength - _terminalMaxRows)) then
{
	_terminalScrollPosition = _terminalBufferLength - _terminalMaxRows;
	_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition];
};

if (_terminalScrollPosition < 0) then
{
	_terminalScrollPosition = 0;
	_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition];
};


if (_terminalBufferLength > _terminalMaxRows) then
{
	_terminalBufferVisable = _terminalBufferVisable select [(_terminalBufferLength - _terminalMaxRows) - _terminalScrollPosition, _terminalMaxRows];
};

_terminal set ["AE3_terminalBufferVisable", _terminalBufferVisable];

_computer setVariable ["AE3_terminal", _terminal];