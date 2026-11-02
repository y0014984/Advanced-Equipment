// File: fnc_terminal_updatePromptPointer.sqf
/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Updates the terminal prompt pointer (current working directory display).
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
 *
 * Public: No
 */

params ["_computer"];

private _pointer = _computer getVariable "AE3_filepointer";
private _path  = _pointer joinString "/";

if (count _pointer != 0) then
{
	_path = "/" + _path;
};

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";
private _hostname = ([_computer] call AE3_armaos_fnc_computer_getHostname);

_terminal set ["AE3_terminalPrompt", format ["%1@%2:%3/>", _username, _hostname, _path]];

_computer setVariable ["AE3_terminal", _terminal];
