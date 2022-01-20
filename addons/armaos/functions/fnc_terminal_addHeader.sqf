/**
 * Adds the terminal header lines to the terminal of a given computer. 
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _header = [] call AE3_armaos_fnc_terminal_getHeaderText;

[_computer, _header] call AE3_armaos_fnc_terminal_addLines;