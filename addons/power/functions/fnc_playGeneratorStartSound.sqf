params ["_entity"];

_filename = "z\ae3\addons\power\sounds\GeneratorStartSound.ogg";
_isInside = false;
_distance = 100;
_volume = 5;

playSound3D [_filename, _entity, _isInside, getPos _entity, _volume, 1, _distance, 0];
sleep 6;

_handle = [_entity] spawn AE3_power_fnc_playGeneratorRunningSound;
_entity setVariable ['AE3_generatorRunningSoundHandle', _handle, true];