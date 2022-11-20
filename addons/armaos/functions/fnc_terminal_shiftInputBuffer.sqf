/**
 * Shifts the input buffer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: If to the right <BOOL>
 * 2: If to the end <BOOL>
 *
 * Results:
 * None
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