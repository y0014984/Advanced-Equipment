// File: fnc_mailRoute.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Routes an email by registered address and delivers it to the recipient laptop.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Client owner to receive the browser reply
 * 1: _rid <STRING> - Browser request id
 * 2: _senderNetId <STRING> - Sending laptop netId
 * 3: _from <STRING> - Registered sender address
 * 4: _to <STRING> - Recipient address
 * 5: _subject <STRING> - Subject line
 * 6: _body <STRING> - Email body
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_owner", -1, [0]], ["_rid", "", [""]], ["_senderNetId", "", [""]], ["_from", "", [""]], ["_to", "", [""]], ["_subject", "", [""]], ["_body", "", [""]]];

if (!isServer) exitWith {};

private _res = createHashMapFromArray [["error", ""]];
private _reply = {
	params ["_owner", "_rid", "_payload"];
	[_owner, _rid, "mail_send", _payload] call AE3_desktop_fnc_routeReply;
};
private _sender = objectFromNetId _senderNetId;
private _registry = missionNamespace getVariable ["AE3_mail_addresses", createHashMap];
private _fromEntry = _registry getOrDefault [toLower ([_from] call CBA_fnc_trim), []];
private _toEntry = _registry getOrDefault [toLower ([_to] call CBA_fnc_trim), []];
if (isNull _sender || {_fromEntry isEqualTo [] || {_toEntry isEqualTo []}}) exitWith {
	_res set ["error", "bad_addr"];
	[_owner, _rid, _res] call _reply;
};
if ((_fromEntry param [0, ""]) isNotEqualTo _senderNetId) exitWith {
	_res set ["error", "bad_sender"];
	[_owner, _rid, _res] call _reply;
};

private _target = objectFromNetId (_toEntry param [0, ""]);
private _isSelf = _target isEqualTo _sender;
private _connected = {
	params ["_device"];
	// Online-only reachability: the device just needs to be powered on, regardless of topology.
	(_device getVariable ["AE3_power_powerState", 0]) == 1
};
private _senderPowered = (_sender getVariable ["AE3_power_powerState", 0]) == 1;
if (isNull _target || {(!_isSelf && {!([_sender] call _connected) || {!([_target] call _connected)}}) || {_isSelf && {!_senderPowered}}}) exitWith {
	_res set ["error", "unreachable"];
	[_owner, _rid, _res] call _reply;
};

[_target, _fromEntry param [1, _from], _subject, _body, _toEntry param [1, _to]] call AE3_desktop_fnc_addEmail;

// Write a sent copy to the sender's filesystem.
private _sfs = _sender getVariable ["AE3_filesystem", nil];
if (!isNil "_sfs") then
{
	private _sentReceived = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
	private _sentFileName = format ["mail_%1", round (CBA_missionTime * 10)];
	private _sentContent = format ["Received: %1%2From: %3%2To: %4%2Subject: %5%2%2%6", _sentReceived, endl, _fromEntry param [1, _from], _toEntry param [1, _to], _subject, _body];
	try
	{
		[[], _sfs, "/var/sent", "root", "root", [[true, true, true], [true, false, true]]] call AE3_filesystem_fnc_ensureDir;
		[[], _sfs, format ["/var/sent/%1", _sentFileName], _sentContent, "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
		_sender setVariable ["AE3_filesystem", _sfs, [_sender] call AE3_armaos_fnc_computer_getLocality];
		// Nudge the sender's open Mail app to re-pull so the message appears in its Sent box
		// immediately, without relying on a manual refresh.
		private _senderMutex = _sender getVariable ["AE3_computer_mutex", objNull];
		if (!isNull _senderMutex && {_senderMutex isKindOf "CAManBase"}) then
		{
			["ae3_desktop_mailNotify", [_fromEntry param [1, _from]], _senderMutex] call CBA_fnc_targetEvent;
		};
	}
	catch {};
};

_res set ["ok", true];
[_owner, _rid, _res] call _reply;
