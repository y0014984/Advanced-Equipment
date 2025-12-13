/*
 * Author: Root, Wasserstoff
 * Description: Removes a character from the terminal input buffer at the current cursor position.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_removeCharFromInput;
 *
 * Public: No
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _terminalPasswordBuffer = _terminal get "AE3_terminalInputBuffer";

_terminalPasswordBuffer set [0, (_terminalPasswordBuffer select 0) select [0, (count (_terminalPasswordBuffer select 0)) - 1]];

_terminal set ["AE3_terminalInputBuffer", _terminalPasswordBuffer];

_computer setVariable ["AE3_terminal", _terminal];
