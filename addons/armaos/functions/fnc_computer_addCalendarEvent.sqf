// File: fnc_computer_addCalendarEvent.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Adds a calendar/intel event to a computer's calendar store (AE3_calendar_events).
 * Events are small lore entries (a meeting, an intel note) shown in the web desktop Calendar app on
 * a given date - past, present or future. Must run on the server; the store is broadcast so every
 * client's Calendar reads it locally with no per-open round-trip (the data set is tiny and rarely
 * written).
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer to add the event to
 * 1: _date <STRING> - ISO date "YYYY-MM-DD"
 * 2: _title <STRING> - Short event title
 * 3: _location <STRING> (Optional, default: "") - Location text
 * 4: _body <STRING> (Optional, default: "") - Longer description / intel body
 * 5: _time <STRING> (Optional, default: "") - Time of day "HH:MM" (blank = all-day)
 *
 * Return Value:
 * Success <BOOL>
 *
 * Example:
 * [_laptop, "2026-06-19", "Handover", "Pier 4", "Two operatives meet at dusk.", "18:30"] call AE3_armaos_fnc_computer_addCalendarEvent;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_date", "", [""]], ["_title", "", [""]], ["_location", "", [""]], ["_body", "", [""]], ["_time", "", [""]]];

if (!isServer) exitWith { false };
if (isNull _computer) exitWith { false };
if (_date isEqualTo "" || _title isEqualTo "") exitWith { false };

// Basic ISO date sanity check ("YYYY-MM-DD"); reject anything else so the UI grid stays consistent.
if !(_date regexMatch "^\d{4}-\d{2}-\d{2}$") exitWith { false };

// Event tuple keeps date/title/location/body in their original positions; time is appended so older
// readers stay valid and new readers can show it.
private _events = +(_computer getVariable ["AE3_calendar_events", []]);
_events pushBack [_date, _title, _location, _body, _time];
_computer setVariable ["AE3_calendar_events", _events, true];

// Nudge any open web Calendar to re-pull the (now broadcast) store so the event shows immediately.
["ae3_desktop_calChanged", []] call CBA_fnc_globalEvent;

true
