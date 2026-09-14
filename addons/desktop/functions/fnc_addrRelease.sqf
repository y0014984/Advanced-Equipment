// File: fnc_addrRelease.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Releases an email address owned by a laptop.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Client owner to receive the browser reply
 * 1: _rid <STRING> - Browser request id
 * 2: _computerNetId <STRING> - Laptop netId
 * 3: _address <STRING> - Email address to release
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_owner", -1, [0]], ["_rid", "", [""]], ["_computerNetId", "", [""]], ["_address", "", [""]]];

if (!isServer) exitWith {};

private _registry = missionNamespace getVariable ["AE3_mail_addresses", createHashMap];
private _key = toLower ([_address] call CBA_fnc_trim);
private _entry = _registry getOrDefault [_key, []];
private _res = createHashMapFromArray [["error", ""]];
if (_entry isEqualTo [] || {(_entry param [0, ""]) isNotEqualTo _computerNetId}) then {
	_res set ["error", "not_found"];
} else {
	_registry deleteAt _key;
	missionNamespace setVariable ["AE3_mail_addresses", _registry, true];
	_res set ["ok", true];
};
[_owner, _rid, "addr_delete", _res] call AE3_desktop_fnc_routeReply;
