// File: fnc_addrRegister.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Claims an email address for a laptop in the mission-wide address registry.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Client owner to receive the browser reply
 * 1: _rid <STRING> - Browser request id
 * 2: _computerNetId <STRING> - Laptop netId
 * 3: _address <STRING> - Email address requested by the user
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_owner", -1, [0]], ["_rid", "", [""]], ["_computerNetId", "", [""]], ["_address", "", [""]]];

if (!isServer) exitWith {};

private _res = createHashMapFromArray [["error", ""]];
private _computer = objectFromNetId _computerNetId;
_address = [_address] call CBA_fnc_trim;
if (isNull _computer || {_address isEqualTo "" || {(_address find "@") < 0}}) exitWith {
	_res set ["error", "bad_addr"];
	[_owner, _rid, "addr_create", _res] call AE3_desktop_fnc_routeReply;
};

private _key = toLower _address;
private _registry = missionNamespace getVariable ["AE3_mail_addresses", createHashMap];
private _existing = _registry getOrDefault [_key, []];
if (_existing isNotEqualTo [] && {(_existing param [0, ""]) isNotEqualTo _computerNetId}) exitWith {
	_res set ["error", "taken"];
	[_owner, _rid, "addr_create", _res] call AE3_desktop_fnc_routeReply;
};

_registry set [_key, [_computerNetId, _address]];
missionNamespace setVariable ["AE3_mail_addresses", _registry, true];
_res set ["ok", true];
[_owner, _rid, "addr_create", _res] call AE3_desktop_fnc_routeReply;
