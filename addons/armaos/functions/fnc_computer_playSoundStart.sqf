/**
 * Plays a 3D computer start sound on the position of a given computer object.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */
 
 params ["_computer"];

_filename = "z\ae3\addons\armaos\sounds\ComputerStartSound.ogg";
_isInside = false;
_distance = 50;
_volume = 5;

playSound3D [_filename, _computer, _isInside, getPos _computer, _volume, 1, _distance, 0];
sleep 5;