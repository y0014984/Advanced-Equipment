/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Sets the command line input to a command from history based on history index.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _key <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _key] call AE3_armaos_fnc_terminal_setCommandLineByHistory;
 *
 * Public: No
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_computer", "_key"]; 

private _terminal = _computer getVariable "AE3_terminal";

private _username = _terminal get "AE3_terminalLoginUser";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalPrompt = _terminal get "AE3_terminalPrompt";

private _lastBufferLineIndex = (count _terminalBuffer) - 1;
private _lastBufferLine = "";

private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";
_terminalCommandHistory = _terminalCommandHistory get _username;
private _terminalCommandHistoryIndex = _terminal get "AE3_terminalCommandHistoryIndex";

private _terminalCommandHistoryLength = count _terminalCommandHistory;

if (_key isEqualTo DIK_UPARROW) then
{
    if (_terminalCommandHistoryIndex == -1) then
    {
        _terminalCommandHistoryIndex = _terminalCommandHistoryLength - 1;
    }
    else
    {
        if (_terminalCommandHistoryIndex > 0) then
        {
            _terminalCommandHistoryIndex = _terminalCommandHistoryIndex - 1;
        };
    };
};

if (_key isEqualTo DIK_DOWNARROW) then
{
    if (_terminalCommandHistoryIndex == (_terminalCommandHistoryLength - 1)) then
    {
        _terminalCommandHistoryIndex = -1;
    }
    else
    {
        if ((_terminalCommandHistoryIndex < (_terminalCommandHistoryLength - 1)) && (_terminalCommandHistoryIndex != -1)) then
        {
            _terminalCommandHistoryIndex = _terminalCommandHistoryIndex + 1;
        };
    };
};

if (_terminalCommandHistoryIndex != -1) then
{
    _terminal set ["AE3_terminalInputBuffer", [(_terminalCommandHistory select _terminalCommandHistoryIndex), ""]];
}
else
{
    _terminal set ["AE3_terminalInputBuffer", ["", ""]];
};
_lastBufferLine = [_terminalPrompt];

_terminalBuffer set [_lastBufferLineIndex, _lastBufferLine];

_terminalCursorPosition = (count _lastBufferLine);

_terminal set ["AE3_terminalBuffer", _terminalBuffer];
_terminal set ["AE3_terminalCursorPosition", _terminalCursorPosition];
_terminal set ["AE3_terminalCommandHistoryIndex", _terminalCommandHistoryIndex];

_computer setVariable ["AE3_terminal", _terminal];
