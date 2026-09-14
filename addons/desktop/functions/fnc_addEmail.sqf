// File: fnc_addEmail.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Adds an email to a laptop's /var/mail directory (server-side; routed from
 * clients). Mission makers use this to plant intel emails; the Mail desktop app and
 * 'cat /var/mail/<file>' display them. An active terminal/desktop user gets a notification.
 *
 * Arguments:
 * 0: _target <OBJECT|STRING> - Target laptop, its netId, or "all" (all initialized computers)
 * 1: _from <STRING> - Sender shown in the email
 * 2: _subject <STRING> - Subject line
 * 3: _body <STRING> - Email body (use endl for line breaks)
 * 4: _to <STRING> (Optional, default: "") - Recipient shown in the email
 * 5: _receivedTime <STRING> (Optional, default: "") - Override received time (HH:MM); blank = current time
 * 6: _createFrom <BOOL> (Optional, default: false) - Register From address in the mission address book
 * 7: _createTo <BOOL> (Optional, default: false) - Register To address in the mission address book
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "informant", "Convoy schedule", "They move at 0400." ] call AE3_desktop_fnc_addEmail;
 * ["all", "HQ", "Briefing", "Check the safehouse."] call AE3_desktop_fnc_addEmail;
 *
 * Public: Yes
 */

params ["_target", "_from", "_subject", "_body", ["_to", ""], ["_receivedTime", ""], ["_createFrom", false], ["_createTo", false]];

// Normalise the address-book flags to strict booleans so a non-bool handle (e.g. a Number coming from
// a 3DEN checkbox attribute) can never reach the boolean logic below.
_createFrom = _createFrom isEqualTo true;
_createTo = _createTo isEqualTo true;

if (!isServer) exitWith
{
	private _targetId = if (_target isEqualType objNull) then { netId _target } else { _target };
	["ae3_desktop_addEmail", [_targetId, _from, _subject, _body, _to, _receivedTime, _createFrom, _createTo]] call CBA_fnc_serverEvent;
};

private _computers = [];
switch (true) do
{
	case (_target isEqualType objNull): { _computers = [_target]; };
	case (_target isEqualTo "all"):     { _computers = +(missionNamespace getVariable ["ae3_desktop_computers", []]); };
	default                             { _computers = [objectFromNetId _target]; };
};

private _receivedStr = if (_receivedTime isNotEqualTo "") then { _receivedTime } else { [dayTime, "HH:MM"] call BIS_fnc_timeToString };
private _toLine = ["", format ["To: %1%2", _to, endl]] select (_to isNotEqualTo "");
private _content = format ["Received: %1%2From: %3%2%4Subject: %5%2%2%6", _receivedStr, endl, _from, _toLine, _subject, _body];
private _fileName = format ["mail_%1", round (CBA_missionTime * 10)];

// Writes the mail file into a laptop's filesystem and, if someone is on the laptop, nudges their
// terminal/Mail app to refresh. When the laptop is in use, the authoritative filesystem lives on
// the user's client, so its current copy is pulled first and the result is pushed back to that
// client (and the refresh is fired afterwards) - otherwise the write would land on the server's
// stale copy and never reach the open session. Runs in a scheduled thread so getRemoteVar can wait.
private _deliver = {
	params ["_computer", "_content", "_fileName", "_from", "_holder"];
	private _owner = if (isNull _holder) then { 2 } else { owner _holder };

	if (isMultiplayer && _owner != 2) then
	{
		[_computer, "AE3_filesystem", _owner] call AE3_main_fnc_getRemoteVar; // authoritative copy
	};

	private _filesystem = _computer getVariable ["AE3_filesystem", nil];
	if (isNil "_filesystem") exitWith {};

	try
	{
		[[], _filesystem, "/var/mail", "root", "root", [[true, true, true], [true, false, true]]] call AE3_filesystem_fnc_ensureDir;
		[[], _filesystem, format ["/var/mail/%1", _fileName], _content, "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
		// Publish the updated filesystem so a laptop currently in use receives the mail without
		// exiting and re-entering the desktop.
		_computer setVariable ["AE3_filesystem", _filesystem, _owner];
	}
	catch
	{
		WARNING_1("Could not deliver email: %1",_exception);
	};

	// Notify whoever is using the laptop right now: the terminal shell banner and the open web Mail
	// app, so the new mail shows without polling or a manual refresh. Fired after the filesystem
	// push so the Mail app re-lists a copy that already contains the new message.
	if (!isNull _holder && {_holder isKindOf "CAManBase"}) then
	{
		["ae3_network_imNotify", [_computer, _from], _holder] call CBA_fnc_targetEvent;
		["ae3_desktop_mailNotify", [_from], _holder] call CBA_fnc_targetEvent;
	};

	[_computer, "\z\ae3\addons\flashdrive\audio\mail_received.ogg"] remoteExecCall ["AE3_desktop_fnc_playDeviceSound", 0];
};

{
	if (!isNull _x && {_x getVariable ["AE3_cap_hasFilesystem", false]}) then
	{
		private _mutexHolder = _x getVariable ["AE3_computer_mutex", objNull];
		[_x, _content, _fileName, _from, _mutexHolder] spawn _deliver;
	};
} forEach _computers;

// Auto-register lore addresses in the mission-wide address book when Zeus plants the email. Each
// address is owned by the laptop this email targets, so the router (fnc_mailRoute) delivers and
// authorises it against that laptop. A broadcast to "all" has no single owner, so nothing is claimed.
private _targetNetId = switch (true) do
{
	case (_target isEqualType objNull): { netId _target };
	case (_target isEqualTo "all"):     { "" };
	default                             { _target };
};
private _toRegister = [];
if (_createFrom && _from isNotEqualTo "" && {(_from find "@") >= 0}) then { _toRegister pushBack _from; };
if (_createTo && _to isNotEqualTo "" && {(_to find "@") >= 0}) then { _toRegister pushBack _to; };
if (_targetNetId isNotEqualTo "" && {_toRegister isNotEqualTo []}) then
{
	private _registry = missionNamespace getVariable ["AE3_mail_addresses", createHashMap];
	{
		private _key = toLower _x;
		if ((_registry getOrDefault [_key, []]) isEqualTo []) then
		{
			_registry set [_key, [_targetNetId, _x]];
		};
	} forEach _toRegister;
	missionNamespace setVariable ["AE3_mail_addresses", _registry, true];
};
