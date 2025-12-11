/*
 * Author: Root, y0014984
 * Description: Closes a desk by animating all drawers closed, hiding lids, and showing wing covers.
 * Updates ACE3 interaction availability via manageAce3Interactions with unwrapped state.
 *
 * Arguments:
 * 0: _desk <OBJECT> - The desk to close
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [_desk] call AE3_interaction_fnc_desk_close;
 *
 * Public: Yes
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

[_desk, "unwrapped", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;
