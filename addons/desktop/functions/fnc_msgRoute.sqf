// File: fnc_msgRoute.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Routes a Messenger message by handle and records both sides' conversation files. The
 * sending handle is chosen by the client (so a laptop with several handles can converse under any of
 * them); each conversation file is keyed by the (own handle, peer handle) pair so distinct identities
 * keep separate chat boxes on both sides.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Client owner to receive the browser reply
 * 1: _rid <STRING> - Browser request id
 * 2: _senderNetId <STRING> - Sending laptop netId
 * 3: _toHandle <STRING> - Recipient handle
 * 4: _text <STRING> - Message body
 * 5: _fromWanted <STRING> (Optional) - Handle to send as; blank or unowned falls back to the first
 *    handle registered to the sending laptop
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_owner", -1, [0]], ["_rid", "", [""]], ["_senderNetId", "", [""]], ["_toHandle", "", [""]], ["_text", "", [""]], ["_fromWanted", "", [""]]];

if (!isServer) exitWith {};

private _res = createHashMapFromArray [["error", ""]];
private _reply = {
	params ["_owner", "_rid", "_payload"];
	[_owner, _rid, "chat_send", _payload] call AE3_desktop_fnc_routeReply;
};
private _sender = objectFromNetId _senderNetId;
private _registry = missionNamespace getVariable ["AE3_msg_handles", createHashMap];
private _toKey = toLower ([_toHandle] call CBA_fnc_trim);
private _toEntry = _registry getOrDefault [_toKey, []];
if (isNull _sender || {_toEntry isEqualTo []}) exitWith { _res set ["error", "unreachable"]; [_owner, _rid, _res] call _reply; };

private _target = objectFromNetId (_toEntry param [0, ""]);
if (isNull _target) exitWith { _res set ["error", "unreachable"]; [_owner, _rid, _res] call _reply; };
private _isSelf = _target isEqualTo _sender;

private _connected = {
	params ["_device"];
	// Online-only reachability: the device just needs to be powered on, regardless of topology.
	(_device getVariable ["AE3_power_powerState", 0]) == 1
};
private _senderPowered = (_sender getVariable ["AE3_power_powerState", 0]) == 1;
if ((!_isSelf && {!([_sender] call _connected) || {!([_target] call _connected)}}) || {_isSelf && {!_senderPowered}}) exitWith {
	_res set ["error", "unreachable"];
	[_owner, _rid, _res] call _reply;
};

// Resolve the sending handle: prefer the one the client asked for when it is registered to this
// laptop, otherwise fall back to the laptop's first handle so single-handle use is unchanged.
private _wantKey = toLower ([_fromWanted] call CBA_fnc_trim);
private _fromHandle = "";
{
	private _entry = _registry get _x;
	if ((_entry param [0, ""]) isEqualTo _senderNetId) then {
		if (_fromHandle isEqualTo "" || _x isEqualTo _wantKey) then { _fromHandle = _entry param [1, _x]; };
	};
} forEach (keys _registry);
if (_fromHandle isEqualTo "") then { _fromHandle = "@" + (_sender getVariable ["ace_cargo_customName", "unknown"]); };
private _toDisplay = _toEntry param [1, _toHandle];
private _time = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
_text = _text regexReplace ["[\r\n]+", " "];

private _safe = {
	params ["_value"];
	_value regexReplace ["[^A-Za-z0-9@._-]", "_"]
};
// Conversation files are named "<ownHandle>+<peerHandle>"; '+' cannot appear in a safe handle, so
// the pair always splits back cleanly (see AE3_desktop_fnc_chatPullServer).
private _deliver = {
	params ["_device", "_self", "_peer", "_dir", "_time", "_text", "_safe"];
	private _filesystem = _device getVariable ["AE3_filesystem", nil];
	if (isNil "_filesystem") exitWith {};
	private _file = ([_self] call _safe) + "+" + ([_peer] call _safe);
	private _line = format ["%1|%2|%3", _dir, _time, _text];
	try {
		[[], _filesystem, "/var/chat", "root", "root", [[true, true, true], [true, false, true]]] call AE3_filesystem_fnc_ensureDir;
		[[], _filesystem, "/var/chat/" + _file, "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
		[[], _filesystem, "/var/chat/" + _file, "root", _line + endl, true] call AE3_filesystem_fnc_writeToFile;
		_device setVariable ["AE3_filesystem", _filesystem, [_device] call AE3_armaos_fnc_computer_getLocality];
	} catch {
		WARNING_1("Could not deliver message: %1",_exception);
	};
};

[_target, _toDisplay, _fromHandle, "i", _time, _text, _safe] call _deliver;
[_sender, _fromHandle, _toDisplay, "o", _time, _text, _safe] call _deliver;

private _mutexHolder = _target getVariable ["AE3_computer_mutex", objNull];
if (!isNull _mutexHolder && {_mutexHolder isKindOf "CAManBase"}) then {
	["ae3_desktop_msgNotify", [_fromHandle], _mutexHolder] call CBA_fnc_targetEvent;
};

_res set ["ok", true];
[_owner, _rid, _res] call _reply;
