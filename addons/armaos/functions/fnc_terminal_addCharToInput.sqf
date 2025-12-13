/*
 * Author: Root, Wasserstoff
 * Description: Adds a character to the terminal input buffer at the current cursor position.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _inputChar <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _inputChar] call AE3_armaos_fnc_terminal_addCharToInput;
 *
 * Public: No
 */

params ["_computer", "_inputChar"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalInputBuffer = ["", ""];

if (!isNil { _terminal get "AE3_terminalInputBuffer" }) then 
{
	_terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";
};

_terminalInputBuffer set [0, (_terminalInputBuffer select 0) + _inputChar];
_terminal set ["AE3_terminalInputBuffer", _terminalInputBuffer];

_computer setVariable ["AE3_terminal", _terminal];
