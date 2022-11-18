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
private _terminalRenderedBuffer = _terminal get "AE3_terminalRenderedBuffer";
private _terminalMaxRows = _terminal get "AE3_terminalMaxRows";
private _terminalApplication = _terminal get "AE3_terminalApplication";

private _terminalInputBuffer = ["", ""];

if (!isNil { _terminal get "AE3_terminalInputBuffer" }) then 
{
	_terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";
};

private _terminalScrollPosition = _terminal get "AE3_terminalScrollPosition";

private _terminalRenderedBufferLength = count _terminalRenderedBuffer;
private _lastBufferLineIndex = _terminalRenderedBufferLength - 1;

// + to preserve reference and force copy
private _terminalRenderedBufferVisable = +_terminalRenderedBuffer;
private _buffer = +_terminalBuffer;

// ENHANCEMENT: add block sign (needs new or modified font) instead of ¶ sign to the end of the _terminalRenderedBufferVisable
private _lastBufferVisableLineIndex = (count _buffer) - 1;
private _lastBufferVisableLine = _buffer # (_lastBufferVisableLineIndex);

if (_terminalApplication isEqualTo "PASSWORD") then
{
	_lastBufferVisableLine pushBack ((_terminalInputBuffer select 0) regexReplace [".", "*"]) + "¶" + ((_terminalInputBuffer select 1) regexReplace [".", "*"]);
}else
{
	_lastBufferVisableLine pushBack (_terminalInputBuffer select 0) + "¶" + (_terminalInputBuffer select 1);
};

_terminalRenderedBufferVisable set [_lastBufferVisableLineIndex, [_computer, _lastBufferVisableLine] call AE3_armaos_fnc_terminal_renderLine];

// Flatten rendered buffer
_terminalBufferVisable = flatten _terminalRenderedBufferVisable;

if (_terminalScrollPosition > (_terminalRenderedBufferLength - _terminalMaxRows)) then
{
	_terminalScrollPosition = _terminalRenderedBufferLength - _terminalMaxRows;
	_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition];
};

if (_terminalScrollPosition < 0) then
{
	_terminalScrollPosition = 0;
	_terminal set ["AE3_terminalScrollPosition", _terminalScrollPosition];
};


if (_terminalRenderedBufferLength > _terminalMaxRows) then
{
	_terminalBufferVisable = _terminalBufferVisable select [(_terminalRenderedBufferLength - _terminalMaxRows) - _terminalScrollPosition, _terminalMaxRows];
};

_terminal set ["AE3_terminalBufferVisable", _terminalBufferVisable];

_computer setVariable ["AE3_terminal", _terminal];