/*
 * Author: Root
 * Description: Re-renders the entire terminal buffer, converting raw text to formatted structured text.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_reRenderBuffer;
 *
 * Public: No
 */

params['_computer'];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalBuffer = _terminal get "AE3_terminalBuffer";

private _render = [];

{

	_render pushBack ([_computer, _x] call AE3_armaos_fnc_terminal_renderLine);

} forEach _terminalBuffer;

_terminal set ["AE3_terminalRenderedBuffer", _render];
