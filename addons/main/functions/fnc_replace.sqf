/**
  * Replaces an object with an object with the given type.
  * 
  * Arguments:
  * 0: Object to replace <OBJECT>
  * 1: Object type <STRIGN>
  * 
  * Return:
  * None
  *
  */

params["_from", "_to_type"];

if(!isServer) exitWith {};

[_from, _to_type] spawn 
{
  params ["_from", "_to_type"];

  sleep 5;

  private _pos = getPosATL _from;
  private _rot = [vectorDir _from, vectorUp _from];

  private _totalDamage = damage _from;
  private _fuel = fuel _from;

  deleteVehicle _from;

  private _to = createVehicle [_to_type, _pos, [], 0, "CAN_COLLIDE"];

  _to setVectorDirAndUp _rot;
  _to setDamage _totalDamage;
  _to setFuel _fuel;

  if(isMultiplayer && isDedicated) then
  {
    _to call AE3_power_fnc_compileDevice;
  };
};