/*
 * Author: Root, y0014984
 * Description: Closes a laptop by animating the lid to the closed position (animation phase 1).
 *
 * Arguments:
 * 0: _laptop <OBJECT> - The laptop to close
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [_laptop] call AE3_interaction_fnc_laptop_close;
 *
 * Public: Yes
 */

params['_laptop'];

_laptop animateSource ["Open_Source", 1, false];

true;
