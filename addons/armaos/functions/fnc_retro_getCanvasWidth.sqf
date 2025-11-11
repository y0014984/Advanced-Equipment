/*
 * Author: Root
 * Description: Returns the width in pixels of a retro graphics canvas.
 *
 * Arguments:
 * 0: _dialog <DISPLAY> - The canvas display
 *
 * Return Value:
 * Canvas width in pixels <NUMBER>
 *
 * Example:
 * private _width = [_canvas] call AE3_armaos_fnc_retro_getCanvasWidth;
 *
 * Public: No
 */

params ["_dialog"];

private _width = _dialog getVariable "AE3_Retro_Width";

_width;
