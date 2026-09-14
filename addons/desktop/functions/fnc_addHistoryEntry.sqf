// File: fnc_addHistoryEntry.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Pre-seeds the browser history of a laptop with an entry (server-side; routed
 * from clients). Mission makers use this to plant intel trails ("what did the previous owner
 * look up?"). History is the plain file /var/log/browser_history.
 *
 * Arguments:
 * 0: _target <OBJECT|STRING> - Target laptop, its netId, or "all"
 * 1: _url <STRING> - The URL to add
 * 2: _timeString <STRING> (Optional, default: random time) - Shown timestamp, e.g. "03:12"
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "intel.root/convoys", "02:47"] call AE3_desktop_fnc_addHistoryEntry;
 *
 * Public: Yes
 */

params ["_target", "_url", ["_timeString", ""]];

if (!isServer) exitWith
{
	private _targetId = if (_target isEqualType objNull) then { netId _target } else { _target };
	["ae3_desktop_addHistoryEntry", [_targetId, _url, _timeString]] call CBA_fnc_serverEvent;
};

if (_timeString isEqualTo "") then
{
	_timeString = format ["%1:%2", [floor random 24, 2] call CBA_fnc_formatNumber, [floor random 60, 2] call CBA_fnc_formatNumber];
};

private _computers = [];
switch (true) do
{
	case (_target isEqualType objNull): { _computers = [_target]; };
	case (_target isEqualTo "all"):     { _computers = +(missionNamespace getVariable ["ae3_desktop_computers", []]); };
	default                             { _computers = [objectFromNetId _target]; };
};

// Writes the history entry into a laptop's filesystem. When the laptop is in use, the authoritative
// filesystem lives on the user's client, so its current copy is pulled first and the result pushed
// back to that client - otherwise the write lands on the server's stale copy (and pushing that copy
// back would clobber the user's live session). Runs in a scheduled thread so getRemoteVar can wait.
private _deliver = {
	params ["_computer", "_url", "_timeString"];
	private _holder = _computer getVariable ["AE3_computer_mutex", objNull];
	private _ownerId = if (isNull _holder) then { 2 } else { owner _holder };

	if (isMultiplayer && _ownerId != 2) then
	{
		[_computer, "AE3_filesystem", _ownerId] call AE3_main_fnc_getRemoteVar; // authoritative copy
	};

	private _filesystem = _computer getVariable ["AE3_filesystem", nil];
	if (isNil "_filesystem") exitWith {};

	try
	{
		[[], _filesystem, "/var/log/browser_history", "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
		[[], _filesystem, "/var/log/browser_history", "root", format ["[%1] %2%3", _timeString, _url, endl], true] call AE3_filesystem_fnc_writeToFile;
		// Publish the updated filesystem so a laptop currently in use sees the entry.
		_computer setVariable ["AE3_filesystem", _filesystem, _ownerId];
	}
	catch
	{
		WARNING_1("Could not seed browser history: %1",_exception);
	};
};

{
	if (!isNull _x && {_x getVariable ["AE3_cap_hasFilesystem", false]}) then
	{
		[_x, _url, _timeString] spawn _deliver;
	};
} forEach _computers;

// Nudge any open Browser to re-read its history so a new entry shows without reopening the app.
["ae3_desktop_webChanged", []] call CBA_fnc_globalEvent;
