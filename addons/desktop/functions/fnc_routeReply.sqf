// File: fnc_routeReply.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sends the result of a server-side web request back to the client that asked for it.
 * The payload is JSON-encoded before it crosses the network event, because only plain strings
 * serialize reliably in multiplayer - a HashMap sent directly arrives empty or not at all on a
 * dedicated server, leaving the browser request unanswered. The receiving client decodes it and
 * hands it to the browser with the original request id, so the JS A3.request promise resolves.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Machine network id of the requesting client
 * 1: _rid <STRING> - Request id echoed back to the browser
 * 2: _command <STRING> - Command name the JS side listens for
 * 3: _payload <ANY> - Result data (HashMap, array or string)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_owner, _rid, "mail_send", _res] call AE3_desktop_fnc_routeReply;
 *
 * Public: No
 */

params [["_owner", 0, [0]], ["_rid", "", [""]], ["_command", "", [""]], ["_payload", []]];

if (_owner <= 0) exitWith {};

["ae3_desktop_routeReply", [_rid, _command, ([_payload] call CBA_fnc_encodeJSON)], _owner] call CBA_fnc_ownerEvent;
