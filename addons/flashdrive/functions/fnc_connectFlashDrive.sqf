params['_computer', '_flashDrive', '_USBInterface'];

_USBInterface params ['_occupied', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];

if(_occupied) exitWith {};

private _object = [player, _flashDrive] call AE3_flashdrive_fnc_item2obj;

if(isNull _object) exitWith {};

_object attachTo [_computer, _rel_pos];
[_object, [_rot_yaw, _rot_pitch, _rot_roll]] call BIS_fnc_setObjectRotation;