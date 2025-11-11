/*
 * Author: Root
 * Description: Replaces an object with a new object of the specified type, preserving position, rotation, damage, and fuel.
 * Must be executed on the server. Waits 5 seconds before replacement.
 *
 * Arguments:
 * 0: _from <OBJECT> - Object to replace
 * 1: _to_type <STRING> - Classname of the new object type
 *
 * Return Value:
 * None
 *
 * Example:
 * [_oldLaptop, "Land_Laptop_03_black_F"] call AE3_main_fnc_replace;
 *
 * Public: No
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
