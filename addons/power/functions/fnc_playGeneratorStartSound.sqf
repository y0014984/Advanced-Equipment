/*
 * Author: Root
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
	sleep 6;
};

[_entity, true] remoteExecCall ["engineOn", _entity];
