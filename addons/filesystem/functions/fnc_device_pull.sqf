// File: fnc_device_pull.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Pulls a device's filesystem from the server onto this client and marks the copy as
 * synced for the local player (AE3_filesystem_syncedBy, set on this client and the server). Until the
 * pull completes the mark is cleared, so the server does not treat this client's copy as
 * authoritative and the client does not push it back. Must run scheduled.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device with an AE3_filesystem
 *
 * Return Value:
 * true when the pull completed <BOOL>
 *
 * Example:
 * [_laptop] call AE3_filesystem_fnc_device_pull;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith { false };

private _targets = [clientOwner, 2];
_computer setVariable ["AE3_filesystem_syncedBy", objNull, _targets];

private _done = [_computer, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;
if (_done isEqualTo true) then
{
	_computer setVariable ["AE3_filesystem_syncedBy", player, _targets];
};

_done isEqualTo true
