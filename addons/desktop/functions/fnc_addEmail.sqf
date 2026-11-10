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
private _mailSeq = (missionNamespace getVariable ["AE3_mail_seq", 0]) + 1;
missionNamespace setVariable ["AE3_mail_seq", _mailSeq];
private _fileName = format ["mail_%1_%2", round (CBA_missionTime * 10), _mailSeq];

// Writes the mail file through AE3_filesystem_fnc_device_withFilesystem (pulls the in-use copy from the
// laptop's user and pushes it back), then notifies whoever is on the laptop: the terminal shell banner
// and the open web Mail app, so the new mail shows without polling. Scheduled, so the pull can wait.
private _deliver = {
	params ["_computer", "_content", "_fileName", "_from"];

	[_computer, {
		params ["_filesystem", "_args"];
		_args params ["_mailContent", "_mailFile"];
		[[], _filesystem, "/var/mail", "root", "root", [[true, true, true], [true, false, true]]] call AE3_filesystem_fnc_ensureDir;
		[[], _filesystem, format ["/var/mail/%1", _mailFile], _mailContent, "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
	}, [_content, _fileName]] call AE3_filesystem_fnc_device_withFilesystem;

	private _holder = _computer getVariable ["AE3_computer_mutex", objNull];
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
		[_x, _content, _fileName, _from] spawn _deliver;
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
