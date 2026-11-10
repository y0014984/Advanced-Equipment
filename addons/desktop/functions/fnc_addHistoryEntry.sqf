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

// Writes the history line through AE3_filesystem_fnc_device_withFilesystem (pulls the in-use copy
// from the laptop's user and pushes it back).
private _write = {
	params ["_filesystem", "_args"];
	_args params ["_entryUrl", "_entryTime"];
	[[], _filesystem, "/var/log/browser_history", "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
	[[], _filesystem, "/var/log/browser_history", "root", format ["[%1] %2%3", _entryTime, _entryUrl, endl], true] call AE3_filesystem_fnc_writeToFile;
};

{
	if (!isNull _x && {_x getVariable ["AE3_cap_hasFilesystem", false]}) then
	{
		[_x, _write, [_url, _timeString]] spawn AE3_filesystem_fnc_device_withFilesystem;
	};
} forEach _computers;

// Nudge any open Browser to re-read its history so a new entry shows without reopening the app.
["ae3_desktop_webChanged", []] call CBA_fnc_globalEvent;
