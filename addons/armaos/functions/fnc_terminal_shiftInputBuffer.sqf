/*
 * Author: Root
 * Description: Shifts the terminal input buffer left or right for cursor movement.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _right <STRING> - TODO: Add description
 * 2: _end <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _right, _end] call AE3_armaos_fnc_terminal_shiftInputBuffer;
 *
 * Public: No
 */

params['_computer', '_right', ['_end', false]];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalInputBuffer = ["", ""];

if (!isNil { _terminal get "AE3_terminalInputBuffer" }) then 
{
	_terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";
};

if(_terminalInputBuffer select (parseNumber _right) isEqualTo "") exitWith {};

if (_right) then
{
	if(_end) then
	{
		_terminal set ["AE3_terminalInputBuffer", [(_terminalInputBuffer select 0) + (_terminalInputBuffer select 1), ""]];
	}else
	{
		_terminalInputBuffer set [0, (_terminalInputBuffer select 0) + (((_terminalInputBuffer select 1) select [0, 1]))];
		_terminalInputBuffer set [1, (_terminalInputBuffer select 1) select [1, (count (_terminalInputBuffer select 1))]];
	}
}else
{
	if(_end) then
	{
		_terminal set ["AE3_terminalInputBuffer", ["", (_terminalInputBuffer select 0) + (_terminalInputBuffer select 1)]];
	}else
	{
		_terminalInputBuffer set [1, ((_terminalInputBuffer select 0) select [(count (_terminalInputBuffer select 0)) - 1, (count (_terminalInputBuffer select 0))]) + (_terminalInputBuffer select 1)];
		_terminalInputBuffer set [0, (_terminalInputBuffer select 0) select [0, (count (_terminalInputBuffer select 0)) - 1]];
	}
}
