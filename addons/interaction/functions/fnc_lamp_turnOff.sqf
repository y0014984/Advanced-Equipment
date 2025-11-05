/**
 * Turns off a lamp;
 *
 * Arguments:
 * 0: Lamp <OBJECT>
 *
 * Returns:
 * true
 */

params['_lamp'];

[_lamp, false] remoteExecCall ['BIS_fnc_switchLamp', 0];

[_lamp, "turnedOn", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

true;
