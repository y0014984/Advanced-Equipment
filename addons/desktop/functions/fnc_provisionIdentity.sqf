// File: fnc_provisionIdentity.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Gives a laptop a default mail address and Messenger handle in the mission-wide
 * registries when it finishes initializing, so self-send and laptop-to-laptop mail/messaging work
 * out of the box without the user manually creating an address first. Derived from the laptop's
 * hostname; a numeric suffix is appended on collision. Idempotent: a laptop that already owns an
 * address/handle is left untouched, so user-created entries are never overwritten. Server-only.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop that just became ready
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

if (!isServer) exitWith {};
if (isNull _computer || {!(_computer getVariable ["AE3_cap_hasFilesystem", false])}) exitWith {};

private _netId = netId _computer;

// Sanitised, lowercased base name from the laptop's display name (fallback "laptop").
private _host = _computer getVariable ["ace_cargo_customName", "laptop"];
private _base = toLower (_host regexReplace ["[\s@+/\\:*?""<>|,;]", ""]);
if (_base isEqualTo "") then { _base = "laptop"; };

// Mail address: <base>@lan, unique per laptop. Skip if this laptop already owns one.
private _mailReg = missionNamespace getVariable ["AE3_mail_addresses", createHashMap];
if (((keys _mailReg) findIf { ((_mailReg get _x) param [0, ""]) isEqualTo _netId }) < 0) then {
	private _addr = _base + "@lan";
	private _n = 1;
	while {
		private _existing = _mailReg getOrDefault [toLower _addr, []];
		_existing isNotEqualTo [] && {(_existing param [0, ""]) isNotEqualTo _netId}
	} do {
		_n = _n + 1;
		_addr = format ["%1%2@lan", _base, _n];
	};
	_mailReg set [toLower _addr, [_netId, _addr]];
	missionNamespace setVariable ["AE3_mail_addresses", _mailReg, true];
};

// Messenger handle: @<base>, unique per laptop. Skip if this laptop already owns one.
private _handleReg = missionNamespace getVariable ["AE3_msg_handles", createHashMap];
if (((keys _handleReg) findIf { ((_handleReg get _x) param [0, ""]) isEqualTo _netId }) < 0) then {
	private _handle = "@" + _base;
	private _n = 1;
	while {
		private _existing = _handleReg getOrDefault [toLower _handle, []];
		_existing isNotEqualTo [] && {(_existing param [0, ""]) isNotEqualTo _netId}
	} do {
		_n = _n + 1;
		_handle = format ["@%1%2", _base, _n];
	};
	_handleReg set [toLower _handle, [_netId, _handle]];
	missionNamespace setVariable ["AE3_msg_handles", _handleReg, true];
};
