/**
 * Converts the terminal buffer to lines of structured text. Crops lines, if they are to long.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Results:
 * None
 */

params['_computer'];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalBuffer = _terminal get "AE3_terminalBuffer";

private _render = [];

{

	_render pushBack ([_computer, _x] call AE3_armaos_fnc_terminal_renderLine);

} forEach _terminalBuffer;

_terminal set ["AE3_terminalRenderedBuffer", _render];