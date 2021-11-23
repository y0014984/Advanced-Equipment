//_handle = [_object, _class] execVM "Scripts\OpenClose.sqf";

params ["_object", "_class"];

//_pos = getPos _object;
_pos = (_object) modelToWorld [0,0,0.2];
_dir = getDir _object;

if (_class isEqualTo "CamoNet_wdl_big_F") then
{
	_pos = (_object) modelToWorld [0,0,-1.5];
	_dir = _dir + 90;
};

deleteVehicle _object;

_newObj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];

_newObj setDir _dir;