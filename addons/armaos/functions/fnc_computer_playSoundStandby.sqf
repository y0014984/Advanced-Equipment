/*
 * Author: Root, y0014984
 * Description: Plays a 3D computer standby sound at the position of a given computer object.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to play the sound at
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_computer_playSoundStandby;
 *
 * Public: No
 */

params ["_computer"];

private _filename = "z\ae3\addons\armaos\sounds\ComputerStandbySound.ogg";
private _isInside = false;
private _distance = 50;
private _volume = 5;

playSound3D [_filename, _computer, _isInside, getPos _computer, _volume, 1, _distance, 0];
sleep 5;
