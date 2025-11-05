/**
 * Updates/sets the visible buffer variable in the terminal settings of a given computer by cropping
 * the full terminal buffer to the visible size with respect of eventually scrolling position changes.
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

private _size = _terminal get "AE3_terminalSize";
private _terminalMaxRows = (_terminal get "AE3_terminalMaxRows") * 0.75 / _size;

private _terminalApplication = _terminal get "AE3_terminalApplication";

private _terminalInputBuffer = ["", ""];

if (!isNil { _terminal get "AE3_terminalInputBuffer" }) then 
{
	_terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";
};

private _terminalScrollPosition = _terminal get "AE3_terminalScrollPosition";


// + to preserve reference and force copy
private _terminalRenderedBufferVisible = +_terminalRenderedBuffer;
private _buffer = +_terminalBuffer;

// ENHANCEMENT: add block sign (needs new or modified font) instead of ¶ sign to the end of the _terminalRenderedBufferVisible
private _lastBufferVisibleLineIndex = (count _buffer) - 1;
private _lastBufferVisibleLine = _buffer # (_lastBufferVisibleLineIndex);

if (_terminalApplication isEqualTo "PASSWORD") then
{
	_lastBufferVisibleLine pushBack ((_terminalInputBuffer select 0) regexReplace [".", "*"]) + "¶" + ((_terminalInputBuffer select 1) regexReplace [".", "*"]);
}else
{
	_lastBufferVisibleLine pushBack (_terminalInputBuffer select 0) + "¶" + (_terminalInputBuffer select 1);
};

_terminalRenderedBufferVisible set [_lastBufferVisibleLineIndex, [_computer, _lastBufferVisibleLine] call AE3_armaos_fnc_terminal_renderLine];

// Flatten rendered buffer
private _terminalBufferVisible = flatten _terminalRenderedBufferVisible;
private _terminalRenderedBufferLength = count _terminalBufferVisible;

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
	_terminalBufferVisible = _terminalBufferVisible select [(_terminalRenderedBufferLength - _terminalMaxRows) - _terminalScrollPosition, _terminalMaxRows];
};

_terminal set ["AE3_terminalBufferVisible", _terminalBufferVisible];

_computer setVariable ["AE3_terminal", _terminal];
