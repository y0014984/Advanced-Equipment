/*
 * Author: Root
 * Description: Returns the current text from the terminal input buffer.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_getInput;
 *
 * Public: No
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalInputBuffer = _terminal get "AE3_terminalInputBuffer";

if (isNil "_terminalInputBuffer") exitWith {""};

(_terminalInputBuffer select 0) + (_terminalInputBuffer select 1);
