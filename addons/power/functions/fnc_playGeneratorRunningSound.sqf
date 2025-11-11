/*
 * Author: Root
 * Description: Plays generator running sound in infinite loop using soundEngine from config. Repeats every 4 seconds. Uses 3D positional audio with 100m max distance. Should be spawned when generator starts.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] spawn AE3_power_fnc_playGeneratorRunningSound;
 *
 * Public: No
 */

params ["_entity"];

private _class = typeOf _entity;
getArray (configFile >> "CfgVehicles" >> _class >> "soundEngine") params ["_filename", "_volume", "_speed"];
if(!isNil "_filename") then
{
	while {true} do 
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
		sleep 4;
	};
};
