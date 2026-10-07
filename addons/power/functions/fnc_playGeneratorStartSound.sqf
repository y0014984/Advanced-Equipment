// File: fnc_playGeneratorStartSound.sqf
/*
 * Author: Root, Wasserstoff
 * Description: Plays generator startup sound effect using soundStartEngine from config. Sets generator engine state to on after sound completes. Uses 3D positional audio with 100m max distance.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] spawn AE3_power_fnc_playGeneratorStartSound;
 *
 * Public: No
 */

params ["_entity"];

private _class = typeOf _entity;
getArray (configFile >> "CfgVehicles" >> _class >> "soundStartEngine") params ["_filename", "_volume", "_speed"];

// NOTE: must run spawned (scheduled): callers keep the handle and `terminate` it to cancel
// the pending engineOn when the turn-on is aborted - do not convert the sleep to CBA_fnc_waitAndExecute
if(!isNil "_filename") then
{
	playSound3D [_filename,
			_entity, 
			false, // is inside
			getPosASL _entity, // position (playSound3D expects ASL)
			_volume, // volume
			1, // pitch
			100, // max distance
			0 // offset
			];
	sleep 6;
};

// Starts the running loop on every machine, once the startup sound has finished, which is where the
// engine sound config used to take over. engineOn is kept for a generator registered on a
// vehicle-based object, where it still drives that config.
_entity setVariable ["AE3_power_engineSoundOn", true, true];
[_entity, true] remoteExecCall ["engineOn", _entity];
