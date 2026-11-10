// File: fnc_device_publish.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Stores a device filesystem changed on the server. It goes to the client of the device's
 * current user when the device is in use; otherwise it stays on the server, or is broadcast when
 * AE3_Filesystem_SyncMode is 1. Must run on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device with an AE3_filesystem
 * 1: _filesystem <ARRAY> - Filesystem to store
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, _filesystem] call AE3_filesystem_fnc_device_publish;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_filesystem", [], [[]]]];

if (!isServer || {isNull _computer}) exitWith {};

private _holder = _computer getVariable ["AE3_computer_mutex", objNull];
private _owner = [owner _holder, 2] select (isNull _holder);

if (_owner != 2) exitWith
{
	_computer setVariable ["AE3_filesystem", _filesystem, [2, _owner]];
};

private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
_computer setVariable ["AE3_filesystem", _filesystem, [2, true] select (_syncMode == 1)];
