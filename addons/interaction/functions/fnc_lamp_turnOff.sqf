/*
 * Author: Root
 * Description: Turns off a lamp using BIS_fnc_switchLamp and updates ACE3 interaction state via
 * manageAce3Interactions with turnedOn status.
 *
 * Arguments:
 * 0: _lamp <OBJECT> - The lamp to turn off
 *
 * Return Value:
 * true <BOOL>
 *
 * Example:
 * [_lamp] call AE3_interaction_fnc_lamp_turnOff;
 *
 * Public: Yes
 */

params['_lamp'];

[_lamp, false] remoteExecCall ['BIS_fnc_switchLamp', 0];

[_lamp, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;
