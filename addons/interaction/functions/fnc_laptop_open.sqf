/*
 * Author: Root
 * Description: Opens a laptop by animating the lid to the open position (animation phase 0).
 *
 * Arguments:
 * 0: _laptop <OBJECT> - The laptop to open
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [_laptop] call AE3_interaction_fnc_laptop_open;
 *
 * Public: Yes
 */

params['_laptop'];

_laptop animateSource ["Open_Source", 0, false];

true;
