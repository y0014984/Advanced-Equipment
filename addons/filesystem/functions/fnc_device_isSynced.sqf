// File: fnc_device_isSynced.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns whether this client's copy of a device's filesystem was pulled from the server
 * for the local player (AE3_filesystem_fnc_device_pull). Client pushes are only safe when true.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device with an AE3_filesystem
 *
 * Return Value:
 * Synced <BOOL>
 *
 * Example:
 * if ([_laptop] call AE3_filesystem_fnc_device_isSynced) then { _laptop setVariable ["AE3_filesystem", _fs, 2]; };
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

!isNull _computer && {(_computer getVariable ["AE3_filesystem_syncedBy", objNull]) isEqualTo player}
