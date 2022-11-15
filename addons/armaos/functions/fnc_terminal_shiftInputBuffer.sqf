/**
 * Shifts the input buffer.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Results:
 * None
 */

params['_computer', '_right'];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalInputBuffer = ["", ""];

if (!isNil { _terminal get "AE3_terminalInputBuffer" }) then 
{
	_terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";
};

if(_terminalInputBuffer select (parseNumber _right) isEqualTo "") exitWith {};

if (_right) then
{
	
	_terminalInputBuffer set [0, (_terminalInputBuffer select 0) + (((_terminalInputBuffer select 1) select [0, 1]))];
	_terminalInputBuffer set [1, (_terminalInputBuffer select 1) select [1, (count (_terminalInputBuffer select 1))]];
}else
{
	_terminalInputBuffer set [1, ((_terminalInputBuffer select 0) select [(count (_terminalInputBuffer select 0)) - 1, (count (_terminalInputBuffer select 0))]) + (_terminalInputBuffer select 1)];
	_terminalInputBuffer set [0, (_terminalInputBuffer select 0) select [0, (count (_terminalInputBuffer select 0)) - 1]];
}