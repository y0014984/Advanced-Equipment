/**
 * Plays the generator stop sound.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 * 
 * Returns:
 * None
 */


params ["_entity"];

private _class = typeOf cursorObject;
getArray (configFile >> "CfgVehicles" >> _class >> "soundStopEngine") params ["_filename", "_volume", "_speed"];

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