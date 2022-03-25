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

true;