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

// Writes the calendar line through AE3_filesystem_fnc_device_withFilesystem (pulls the in-use copy
// from the laptop's user and pushes it back).
private _write = {
	params ["_filesystem", "_args"];
	_args params ["_calLine"];
	[[], _filesystem, "/home/user/calendar", "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
	[[], _filesystem, "/home/user/calendar", "root", _calLine, true] call AE3_filesystem_fnc_writeToFile;
};

{
	if (!isNull _x && {_x getVariable ["AE3_cap_hasFilesystem", false]}) then
	{
		[_x, _write, [_line]] spawn AE3_filesystem_fnc_device_withFilesystem;
		// Keep the web Calendar store in sync (ISO date only; truncate time portion if present).
		[_x, _date select [0, 10], _title, "", _details] call AE3_armaos_fnc_computer_addCalendarEvent;
	};
} forEach _computers;
