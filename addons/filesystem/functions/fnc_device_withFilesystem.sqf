// File: fnc_device_withFilesystem.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Runs a mutation against a device's authoritative filesystem and publishes the result.
 * While a device is in use (terminal, desktop or SSH session), the user's client holds the
 * authoritative filesystem copy, so it is pulled from that client first and pushed back to it
 * afterwards; otherwise the server copy is mutated and published per AE3_Filesystem_SyncMode.
 * Writing straight to the server copy during a session would be overwritten when the session ends.
 * Must run on the server. Re-spawns itself when called unscheduled (the pull has to wait).
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device with an AE3_filesystem (laptop, server or flash drive)
 * 1: _code <CODE> - Mutation, called with [_filesystem, _args]; may throw
 * 2: _args <ARRAY> (Optional, default: []) - Arguments forwarded to _code
 *
 * Return Value:
 * true if the mutation ran without an exception, false otherwise <BOOL>
 * (a script handle when called unscheduled)
 *
 * Example:
 * [_laptop, { params ["_fs", "_args"]; [[], _fs, "/tmp/a.txt", "", "root"] call AE3_filesystem_fnc_ensureFile; }] call AE3_filesystem_fnc_device_withFilesystem;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_code", {}, [{}]], ["_args", [], [[]]]];

if (!isServer) exitWith { false };
if (!canSuspend) exitWith { _this spawn AE3_filesystem_fnc_device_withFilesystem };
if (isNull _computer) exitWith { false };

private _holder = _computer getVariable ["AE3_computer_mutex", objNull];
private _owner = [owner _holder, 2] select (isNull _holder);

if (isMultiplayer && _owner != 2) then
{
	[_computer, "AE3_filesystem", _owner] call AE3_main_fnc_getRemoteVar;
};

private _filesystem = _computer getVariable ["AE3_filesystem", nil];
if (isNil "_filesystem") exitWith
{
	ERROR_1("Device %1 has no filesystem initialized",_computer);
	false
};

private _success = true;
try
{
	[_filesystem, _args] call _code;
}
catch
{
	WARNING_2("Filesystem operation on %1 failed: %2",_computer,_exception);
	_success = false;
};

if (_owner != 2) then
{
	_computer setVariable ["AE3_filesystem", _filesystem, _owner];
}
else
{
	private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
	_computer setVariable ["AE3_filesystem", _filesystem, [2, true] select (_syncMode == 1)];
};

_success
