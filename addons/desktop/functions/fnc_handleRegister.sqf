// File: fnc_handleRegister.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Claims a Messenger handle for a laptop in the mission-wide handle registry.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Client owner to receive the browser reply
 * 1: _rid <STRING> - Browser request id
 * 2: _computerNetId <STRING> - Laptop netId
 * 3: _handle <STRING> - Display handle requested by the user
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params [["_owner", -1, [0]], ["_rid", "", [""]], ["_computerNetId", "", [""]], ["_handle", "", [""]]];

if (!isServer) exitWith {};

private _reply = {
	params ["_owner", "_rid", "_payload"];
	[_owner, _rid, "handle_create", _payload] call AE3_desktop_fnc_routeReply;
};
private _res = createHashMapFromArray [["error", ""]];
private _computer = objectFromNetId _computerNetId;
if (isNull _computer) exitWith { _res set ["error", "no_device"]; [_owner, _rid, _res] call _reply; };

_handle = [_handle] call CBA_fnc_trim;
if (_handle isEqualTo "") exitWith { _res set ["error", "bad_handle"]; [_owner, _rid, _res] call _reply; };
if ((_handle select [0, 1]) isNotEqualTo "@") then { _handle = "@" + _handle; };

private _key = toLower _handle;
private _registry = missionNamespace getVariable ["AE3_msg_handles", createHashMap];
private _existing = _registry getOrDefault [_key, []];
if (_existing isNotEqualTo [] && {(_existing param [0, ""]) isNotEqualTo _computerNetId}) exitWith {
	_res set ["error", "taken"];
	[_owner, _rid, _res] call _reply;
};

_registry set [_key, [_computerNetId, _handle]];
missionNamespace setVariable ["AE3_msg_handles", _registry, true];
_res set ["ok", true];
[_owner, _rid, _res] call _reply;
