/**
 * Opens a desk
 *
 * Arguments:
 * 0: Desk <OBJECT>
 *
 * Returns:
 * true
 */

params['_desk'];

_desk animateSource ["Lid_1_hide_source", 1, false];
_desk animateSource ["Lid_2_hide_source", 1, false];
_desk animateSource ["Wing_L_Hide_Source", 0, false];
_desk animateSource ["Wing_R_Hide_Source", 0, false];

private _canDrag = false;
private _dragPosition = [0, 0, 0];
private _dragDirection = 0;

[_desk, _canDrag, _dragPosition, _dragDirection] remoteExecCall ['ace_dragging_fnc_setDraggable', 0, true];

true;