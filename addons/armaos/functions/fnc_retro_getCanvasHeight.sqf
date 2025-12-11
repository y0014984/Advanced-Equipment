/*
 * Author: Root, y0014984
 * Description: Returns the height in pixels of a retro graphics canvas.
 *
 * Arguments:
 * 0: _dialog <DISPLAY> - The canvas display
 *
 * Return Value:
 * Canvas height in pixels <NUMBER>
 *
 * Example:
 * private _height = [_canvas] call AE3_armaos_fnc_retro_getCanvasHeight;
 *
 * Public: No
 */

params ["_dialog"];

private _height = _dialog getVariable "AE3_Retro_Height";

_height;
