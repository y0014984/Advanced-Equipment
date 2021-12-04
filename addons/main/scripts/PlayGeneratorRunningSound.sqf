params ["_entity"];

_filename = "z\ae3\addons\main\sounds\GeneratorRunningSound.ogg";
_isInside = false;
_distance = 100;
_volume = 5;

while {true} do 
{
	playSound3D [_filename, _entity, _isInside, getPos _entity, _volume, 1, _distance, 0];
	sleep 4;
};