//_handle = [_object, _class] execVM "Scripts\OpenClose.sqf";

params ["_object", "_class"];

//_pos = getPos _object;
_pos = (_object) modelToWorld [0,0,0.2];
_dir = getDir _object;

deleteVehicle _object;

_newObj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];

_newObj setDir _dir;