params ["_entity"];

_filename = "z\ae3\addons\main\sounds\ComputerStopSound.ogg";
_isInside = false;
_distance = 50;
_volume = 5;

playSound3D [_filename, _entity, _isInside, getPos _entity, _volume, 1, _distance, 0];
sleep 1;