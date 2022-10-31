/**
  * Replaces an object with an object with the given type.
  * 
  * Arguments:
  * 0: Object to replace <OBJECT>
  * 1: Object type <STRIGN>
  * 2: Texture Source <STRING>
  * 
  * Return:
  * New object <OBJECT>
  *
  */

params['_from', '_to_type', '_to_textureSource'];

if(!isServer) exitWith {};

private _pos = getPosATL _from;
private _rot = [vectorDir _from, vectorUp _from];

private _totalDamage = damage _from;
private _fuel = fuel _from;

deleteVehicle _from;

private _to = createVehicle [_to_type, _pos, [], 0, "CAN_COLLIDE"];

_to setVectorDirAndUp _rot;
_to setDamage _totalDamage;
_to setFuel _fuel;

if (!isNil "_to_textureSource") then {
	[_to, _to_textureSource] call BIS_fnc_initVehicle;
};

_to call AE3_power_fnc_compileDevice;
_to;