/**
 * Plays the generator running sound in a loop.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * None
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
