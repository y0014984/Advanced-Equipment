// File: fnc_device_lock.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Waits until no other server thread holds the device's filesystem, then takes it.
 * Pair every call with AE3_filesystem_fnc_device_unlock. Server, scheduled only.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device with an AE3_filesystem
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_filesystem_fnc_device_lock;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

private _locked = false;
waitUntil
{
	isNil { if !(_computer getVariable ["AE3_filesystem_lock", false]) then { _computer setVariable ["AE3_filesystem_lock", true]; _locked = true; }; };
	_locked
};
