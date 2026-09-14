// File: fnc_addCalendarEvent.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Adds a calendar entry to a laptop's /home/user/calendar file (server-side;
 * routed from clients). Entries appear in the Calendar desktop app and can be read with cat.
 * Line format: "DATE | TITLE | DETAILS".
 *
 * Arguments:
 * 0: _target <OBJECT|STRING> - Target laptop, its netId, or "all"
 * 1: _date <STRING> - Date text, e.g. "2026-06-24 04:00"
 * 2: _title <STRING> - Event title
 * 3: _details <STRING> (Optional, default: "") - Event details
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "2026-06-24 04:00", "Convoy departs", "Route Red, 3 trucks"] call AE3_desktop_fnc_addCalendarEvent;
 *
 * Public: Yes
 */

params ["_target", "_date", "_title", ["_details", ""]];

if (!isServer) exitWith
{
	private _targetId = if (_target isEqualType objNull) then { netId _target } else { _target };
	["ae3_desktop_addCalendarEvent", [_targetId, _date, _title, _details]] call CBA_fnc_serverEvent;
};

private _computers = [];
switch (true) do
{
	case (_target isEqualType objNull): { _computers = [_target]; };
	case (_target isEqualTo "all"):     { _computers = +(missionNamespace getVariable ["ae3_desktop_computers", []]); };
	default                             { _computers = [objectFromNetId _target]; };
};

private _line = format ["%1 | %2 | %3%4", _date, _title, _details, endl];

// Writes the calendar line into a laptop's filesystem. When the laptop is in use, the authoritative
// filesystem lives on the user's client, so its current copy is pulled first and the result pushed
// back to that client - otherwise the write lands on the server's stale copy and never reaches the
// open session. Runs in a scheduled thread so getRemoteVar can wait.
private _deliver = {
	params ["_computer", "_line"];
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
		[[], _filesystem, "/home/user/calendar", "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
		[[], _filesystem, "/home/user/calendar", "root", _line, true] call AE3_filesystem_fnc_writeToFile;
		// Publish the updated filesystem so a laptop currently in use sees the entry.
		_computer setVariable ["AE3_filesystem", _filesystem, _ownerId];
	}
	catch
	{
		WARNING_1("Could not add calendar event: %1",_exception);
	};
};

{
	if (!isNull _x && {_x getVariable ["AE3_cap_hasFilesystem", false]}) then
	{
		[_x, _line] spawn _deliver;
		// Keep the web Calendar store in sync (ISO date only; truncate time portion if present).
		[_x, _date select [0, 10], _title, "", _details] call AE3_armaos_fnc_computer_addCalendarEvent;
	};
} forEach _computers;
