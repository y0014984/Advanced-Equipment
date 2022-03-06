/**
 * Closes a desk
 *
 * Arguments:
 * 0: Desk <OBJECT>
 *
 * Returns:
 * true
 */

params['_desk'];

_desk animateSource ["Drawer_1_move_source", 0, false];
_desk animateSource ["Drawer_2_move_source", 0, false];
_desk animateSource ["Drawer_3_move_source", 0, false];
_desk animateSource ["Drawer_4_move_source", 0, false];
_desk animateSource ["Drawer_5_move_source", 0, false];
_desk animateSource ["Drawer_6_move_source", 0, false];

_desk animateSource ["Lid_1_hide_source", 0, false];
_desk animateSource ["Lid_2_hide_source", 0, false];
_desk animateSource ["Wing_L_Hide_Source", 1, false];
_desk animateSource ["Wing_R_Hide_Source", 1, false];

private _class = typeOf _desk;
private _config = configFile >> "CfgVehicles" >> _class;

private _canDrag = getNumber (_config >> "ace_dragging_canDrag");
private _dragPosition = getArray (_config >> "ace_dragging_dragPosition");
private _dragDirection = getNumber (_config >> "ace_dragging_dragDirection");

if (_canDrag == 1) then { _canDrag = true; } else { _canDrag = false; };

[_desk, _canDrag, _dragPosition, _dragDirection] remoteExecCall ['ace_dragging_fnc_setDraggable', 0];
//[_desk, _canDrag, _dragPosition, _dragDirection] call ace_dragging_fnc_setDraggable;

true;