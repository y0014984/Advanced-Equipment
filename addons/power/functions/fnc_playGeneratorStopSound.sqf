// File: fnc_playGeneratorStopSound.sqf
/*
 * Author: Root, Wasserstoff
 * Description: Plays generator shutdown sound effect using soundStopEngine from config. Sets generator engine state to off before sound. Uses 3D positional audio with 100m max distance.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] spawn AE3_power_fnc_playGeneratorStopSound;
 *
 * Public: No
 */


params ["_entity"];

private _class = typeOf _entity;
getArray (configFile >> "CfgVehicles" >> _class >> "soundStopEngine") params ["_filename", "_volume", "_speed"];

// Silences the running loop on every machine. engineOn is kept for a generator registered on a
// vehicle-based object, where it still drives the engine sound config; the prop-based generator
// classes have no engine simulation and rely on the flag instead.
_entity setVariable ["AE3_power_engineSoundOn", false, true];
[_entity, false] remoteExecCall ["engineOn", _entity];

if(!isNil "_filename") then
{
	playSound3D [_filename, 
			_entity, 
			false, // is inside
			getPos _entity,  // position
			_volume, // volume
			1, // pitch
			100, // max distance
			0 // offset
			];
	sleep 9;
}
