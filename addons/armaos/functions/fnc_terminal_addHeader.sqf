/*
 * Author: Root
 * Description: Adds the terminal header (logo/banner) to the terminal output buffer.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_addHeader;
 *
 * Public: No
 */

params ["_computer"];

private _header = [] call AE3_armaos_fnc_terminal_getHeaderText;

[_computer, _header] call AE3_armaos_fnc_terminal_addLines;
