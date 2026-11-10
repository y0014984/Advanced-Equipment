// File: fnc_device_withFilesystem.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Runs a mutation against a device's authoritative filesystem and publishes the result.
 * While a device is in use (terminal, desktop or SSH session), the user's client holds the
 * authoritative filesystem copy, so it is pulled from that client first and pushed back to it
 * afterwards; otherwise the server copy is mutated and published per AE3_Filesystem_SyncMode.
 * Writing straight to the server copy during a session would be overwritten when the session ends.
 * The holder copy is used only once that client has pulled it (AE3_filesystem_syncedBy, waits up to
 * 30 s); a pull that gets no reply in 10 s or returns nothing keeps the server copy.
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

[_computer] call AE3_filesystem_fnc_device_lock;

private _holder = _computer getVariable ["AE3_computer_mutex", objNull];
private _owner = [owner _holder, 2] select (isNull _holder);

if (isMultiplayer && _owner != 2) then
{
	// Wait until the holder's client has pulled its copy from the server; before that its copy is stale.
	private _deadline = diag_tickTime + 30;
	waitUntil
	{
		sleep 0.1;
		(_computer getVariable ["AE3_filesystem_syncedBy", objNull]) isEqualTo _holder
		|| {(_computer getVariable ["AE3_computer_mutex", objNull]) isNotEqualTo _holder}
		|| {diag_tickTime > _deadline}
	};

	private _pulled = false;
	if ((_computer getVariable ["AE3_filesystem_syncedBy", objNull]) isEqualTo _holder) then
	{
		private _serverCopy = _computer getVariable ["AE3_filesystem", nil];
		_pulled = [_computer, "AE3_filesystem", _owner, 10] call AE3_main_fnc_getRemoteVar;
		if (isNil {_computer getVariable "AE3_filesystem"}) then
		{
			_pulled = false;
			if (!isNil "_serverCopy") then { _computer setVariable ["AE3_filesystem", _serverCopy]; };
		};
	};

	if !(_pulled) then
	{
		if ((_computer getVariable ["AE3_computer_mutex", objNull]) isEqualTo _holder) then
		{
			WARNING_1("Device %1: no synced copy from its user, writing the server copy",_computer);
		};
		_owner = 2;
	};
};

private _filesystem = _computer getVariable ["AE3_filesystem", nil];
if (isNil "_filesystem") exitWith
{
	[_computer] call AE3_filesystem_fnc_device_unlock;
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

[_computer] call AE3_filesystem_fnc_device_unlock;

_success
