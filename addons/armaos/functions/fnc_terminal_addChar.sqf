/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Adds a character to the terminal buffer at the current cursor position.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _inputChar <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _inputChar] call AE3_armaos_fnc_terminal_addChar;
 *
 * Public: No
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
