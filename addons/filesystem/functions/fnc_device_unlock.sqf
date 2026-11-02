// File: fnc_device_unlock.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Releases the device filesystem lock taken by AE3_filesystem_fnc_device_lock.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device with an AE3_filesystem
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_filesystem_fnc_device_unlock;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

_computer setVariable ["AE3_filesystem_lock", false];
