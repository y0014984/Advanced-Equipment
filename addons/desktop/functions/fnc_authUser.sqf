// File: fnc_authUser.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Validates a username/password against a computer's synced AE3_Userlist for the web
 * desktop login. Mirrors the CLI rules: root is blocked unless this computer allows a direct root
 * login. The userlist is broadcast by AE3_armaos_fnc_computer_addUser, so validation is local (no
 * server round-trip), matching the terminal login. Returns a result hashmap for AE3_recv.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The laptop this session is bound to
 * 1: _user <STRING> - Entered username
 * 2: _pass <STRING> - Entered password
 * 3: _authoritative <BOOL> (Optional, default: false) - When true, skip the MP "syncing, retry"
 *    guard and give a definitive verdict (used after the caller has already pulled the userlist).
 *
 * Return Value:
 * Result <HASHMAP> - keys: "ok" <BOOL>, "message" <STRING>, "user" <STRING>, "hostname" <STRING>
 *
 * Example:
 * [_laptop, "admin", "admin123"] call AE3_desktop_fnc_authUser;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_user", "", [""]], ["_pass", "", [""]], ["_authoritative", false, [false]]];

private _fail = {
    params ["_msg"];
    createHashMapFromArray [["ok", false], ["message", _msg]]
};

if (isNull _computer) exitWith { ["No device" ] call _fail };
if (_user isEqualTo "") exitWith { ["Enter a username"] call _fail };

private _rootBlocked = (_user isEqualTo "root") && {!([_computer] call AE3_armaos_fnc_computer_allowsRootLogin)};
if (_rootBlocked) exitWith { ["Root login is disabled"] call _fail };

private _users = _computer getVariable ["AE3_Userlist", createHashMap];

// MP race guard: a just-added account may not have reached this client's cached copy yet (the
// open-time background sync in desktop_openWeb can lose the race against a fast login). Kick a
// non-blocking authoritative re-pull (getRemoteVar self-spawns from this unscheduled context) and
// tell the JS side to retry once - by the next attempt the transfer has completed. Skipped when
// _authoritative (that pass already has the synced list and must give a final verdict). No-op in SP
// (the server-local list is already authoritative).
if (!_authoritative && isMultiplayer && {!(_user in _users)}) exitWith {
    [_computer, "AE3_Userlist"] call AE3_main_fnc_getRemoteVar;
    createHashMapFromArray [["ok", false], ["retry", true], ["message", "Syncing accounts, try again"]]
};

if (!(_user in _users)) exitWith { ["Unknown user"] call _fail };
if ((_users get _user) isNotEqualTo _pass) exitWith { ["Incorrect password"] call _fail };

private _host = _computer getVariable ["ace_cargo_customName", "armaOS"];
createHashMapFromArray [["ok", true], ["user", _user], ["hostname", _host]]
