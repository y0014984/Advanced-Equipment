// File: fnc_sshOpServer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Server-side SSH backend for the web SSH app. Handles connect (auth against the
 * REMOTE device's user list + its SSH-enabled flag) and remote filesystem ops (list/read) plus
 * cross-device copy (pull remote->local, push local->remote). Every op replies to the requesting
 * client through AE3_desktop_fnc_routeReply, echoing the rid so the JS A3.request promise resolves. The
 * body is guarded so any failure still sends exactly one reply, turning errors into a visible
 * verdict instead of a client-side timeout. Server-only.
 *
 * Arguments:
 * 0: _clientOwner <NUMBER> - clientOwner that issued the request
 * 1: _rid <STRING> - request id to echo back
 * 2: _localNetId <STRING> - netId of the laptop running the SSH client
 * 3: _targetIp <ARRAY> - IP address of the remote device, e.g. [192,168,0,5]
 * 4: _user <STRING> - remote username
 * 5: _pass <STRING> - remote password
 * 6: _op <STRING> - "connect" | "ls" | "read" | "pull" | "push"
 * 7: _opArgs <ARRAY> - op-specific strings: [path, dest, content]
 *
 * Return Value:
 * None
 *
 * Public: No
 */

params ["_clientOwner", "_rid", "_localNetId", "_targetIp", "_user", "_pass", "_op", ["_opArgs", [], [[]]]];

if (!isServer) exitWith {};

_opArgs params [["_argPath", ""], ["_argDest", ""], ["_argContent", ""]];

private _debug = (missionNamespace getVariable [QGVAR(debug), false]) || {missionNamespace getVariable ["AE3_DebugMode", false]};

private _reply = {
    params ["_cmd", "_payload"];
    [_clientOwner, _rid, _cmd, _payload] call AE3_desktop_fnc_routeReply;
};

if (_debug) then {
    diag_log text format ["[AE3 desktop] sshOpServer enter op=%1 target=%2 user=%3 rid=%4", _op, _targetIp, _user, _rid];
};

// The cross-device copy ops (pull/push) mutate the filesystem owned by the machine currently using
// the laptop. When a player is on the laptop their client holds the authoritative AE3_filesystem
// copy, so the work is done in a scheduled thread: the owning copy is fetched first (getRemoteVar
// suspends), the file is written, and the result is pushed back to the owner so its cached browser
// view reflects the change. Everything runs off-thread so exactly one reply is still sent.
[_clientOwner, _rid, _localNetId, _targetIp, _user, _pass, _op, _opArgs, _argPath, _argDest, _argContent, _debug, _reply] spawn {
    params ["_clientOwner", "_rid", "_localNetId", "_targetIp", "_user", "_pass", "_op", "_opArgs", "_argPath", "_argDest", "_argContent", "_debug", "_reply"];

private _res = createHashMapFromArray [["error", ""]];

// Validation failures raise a tagged error code (caught below); the engine-level exceptions are
// reported as "internal" so the client always receives a reply rather than timing out.
try {
    private _local = objectFromNetId _localNetId;
    if (isNull _local) then { throw "no_device" };

    ([_local, _targetIp] call AE3_network_fnc_resolve) params ["_target"];

    if (isNull _target) then { throw "no_route" };
    if !(_target getVariable ["AE3_cap_hasTerminal", false]) then { throw "no_route" };
    if ((_target getVariable ["AE3_power_powerState", 0]) != 1) then { throw "offline" };
    // SSH must be enabled on the remote device.
    if !(_target getVariable ["AE3_ssh_enabled", true]) then { throw "ssh_disabled" };
    if (!isNull (_target getVariable ["AE3_computer_mutex", objNull]) && _target isNotEqualTo _local) then { throw "busy" };

    // Authenticate against the remote user list.
    private _authed = ([_target, _user, _pass, true] call AE3_desktop_fnc_authUser) getOrDefault ["ok", false];
    if (!_authed) then { throw "auth_failed" };

    // the remote device decides who is elevated there: root, admin, or one of its own sudoers
    private _fsUser = ["root", _user] select (_user isNotEqualTo "admin" && {!([_target, _user] call AE3_armaos_fnc_computer_isSudoer)});
    private _tfs = _target getVariable ["AE3_filesystem", []];

    switch (_op) do {

        case "connect": {
            _res set ["ok", true];
            _res set ["host", _target getVariable ["ace_cargo_customName", "remote"]];
        };

        case "ls": {
            private _path = _argPath;
            if (_path isEqualTo "") then { _path = "/"; };
            private _entries = [];
            try {
                ([[], _tfs, _path, _fsUser] call AE3_filesystem_fnc_chdir) params ["", "_dir"];
                [_dir, _fsUser, 0] call AE3_filesystem_fnc_hasPermission;
                private _content = _dir select 0;
                private _names = keys _content; _names sort true;
                {
                    private _child = _content get _x;
                    private _link = [(_child select 0)] call AE3_filesystem_fnc_symlinkTarget;
                    _entries pushBack createHashMapFromArray [
                        ["name", _x], ["dir", (_child select 0) isEqualType createHashMap], ["link", _link]
                    ];
                } forEach _names;
                _res set ["entries", _entries];
            } catch { _res set ["error", "denied"]; _res set ["entries", []]; };
        };

        case "read": {
            try {
                private _content = [[], _tfs, _argPath, _fsUser, 0] call AE3_filesystem_fnc_getFile;
                if (_content isEqualType "") then { _res set ["content", _content]; } else { _res set ["error", "not_text"]; };
            } catch { _res set ["error", "denied"]; };
        };

        // Copy a remote file down to the local laptop. The local laptop's authoritative filesystem
        // lives on whichever machine is using it (the SSH client), so its current copy is fetched
        // before writing and the result is pushed straight back to that machine's cached view.
        case "pull": {
            try {
                private _content = [[], _tfs, _argPath, _fsUser, 0] call AE3_filesystem_fnc_getFile;
                [_local, "AE3_filesystem", _clientOwner] call AE3_main_fnc_getRemoteVar;
                private _lfs = _local getVariable ["AE3_filesystem", []];
                [[], _lfs, _argDest, "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
                [[], _lfs, _argDest, "root", _content, false] call AE3_filesystem_fnc_writeToFile;
                _local setVariable ["AE3_filesystem", _lfs, _clientOwner];
                _res set ["ok", true];
            } catch { _res set ["error", "denied"]; };
        };

        // Copy a local file up to the remote device. The local file content is read from the SSH
        // client's authoritative filesystem copy, then written into the remote device's filesystem.
        case "push": {
            try {
                [_local, "AE3_filesystem", _clientOwner] call AE3_main_fnc_getRemoteVar;
                private _lfs = _local getVariable ["AE3_filesystem", []];
                private _content = [[], _lfs, _argPath, "root", 0] call AE3_filesystem_fnc_getFile;
                [[], _tfs, _argDest, "", _fsUser, _fsUser, [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
                [[], _tfs, _argDest, _fsUser, _content, false] call AE3_filesystem_fnc_writeToFile;
                _target setVariable ["AE3_filesystem", _tfs, [_target] call AE3_armaos_fnc_computer_getLocality];
                _res set ["ok", true];
            } catch { _res set ["error", "denied"]; };
        };

        default { _res set ["error", "bad_op"]; };
    };
} catch {
    if (_exception isEqualType "") then {
        _res set ["error", _exception];
    } else {
        _res set ["error", "internal"];
        diag_log text format ["[AE3 desktop] sshOpServer exception op=%1: %2", _op, _exception];
    };
};

if (_debug) then {
    diag_log text format ["[AE3 desktop] sshOpServer reply op=%1 res=%2 rid=%3", _op, _res, _rid];
};

["ssh_" + _op, _res] call _reply;
};
