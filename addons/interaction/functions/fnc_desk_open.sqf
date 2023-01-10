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

_desk animateSource ["Drawer_1_move_source", 0, false];
_desk animateSource ["Drawer_2_move_source", 0, false];
_desk animateSource ["Drawer_3_move_source", 0, false];
_desk animateSource ["Drawer_4_move_source", 0, false];
_desk animateSource ["Drawer_5_move_source", 0, false];
_desk animateSource ["Drawer_6_move_source", 0, false];

_desk animateSource ["Lid_1_hide_source", 1, false];
_desk animateSource ["Lid_2_hide_source", 1, false];
_desk animateSource ["Wing_L_Hide_Source", 0, false];
_desk animateSource ["Wing_R_Hide_Source", 0, false];

[_desk, "unwrapped", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;