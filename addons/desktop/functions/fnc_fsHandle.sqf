// File: fnc_fsHandle.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Filesystem operations for the web desktop Files/Notepad apps (WS-C/D). Operates on
 * the laptop's locally-cached AE3_filesystem copy (pulled via getRemoteVar in
 * AE3_desktop_fnc_desktop_openWeb), reusing the standard AE3 filesystem functions so Unix
 * permissions are enforced exactly like the CLI. Per-user scoping: root, admin and accounts listed in
 * /etc/sudoers act as "root" and bypass permission checks, matching what the sudo command grants in
 * the terminal; every other user is bound by ownership/permission bits.
 * Mutating ops (save/mkdir/delete) push the updated filesystem back to the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop
 * 1: _user <STRING> - The logged-in session user
 * 2: _op <STRING> - "list" | "read" | "save" | "mkdir" | "delete"
 * 3: _data <HASHMAP> - Operation data (keys: "path", "content")
 *
 * Return Value:
 * Result <HASHMAP> - op-specific; always carries "error" ("" on success)
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_user", "", [""]], ["_op", "", [""]], ["_data", createHashMap, [createHashMap]]];

private _res = createHashMapFromArray [["error", ""]];

if (isNull _computer) exitWith { _res set ["error", "no_device"]; _res };

private _fs = _computer getVariable ["AE3_filesystem", []];
if (_fs isEqualTo []) exitWith {
    // The open-time getRemoteVar (desktop_openWeb) may still be in flight on this client. Kick an
    // authoritative re-pull and tell the Files/Notepad app to retry rather than failing outright.
    // No-op in SP, where an empty filesystem genuinely means the device is not initialized.
    [_computer] remoteExecCall ["AE3_armaos_fnc_device_ensureInit", 2];
    [_computer, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;
    _res set ["loading", true];
    _res
};

// Root and admin see/modify everything. A sudoer does too while the mission lets superusers act as root
// without elevating first - the same switch the terminal reads, so an account carries one set of rights
// whichever front-end it is used from. With it off both interfaces hold the sudoer to their own files.
private _elevated = (_user isEqualTo "admin")
    || {
        (missionNamespace getVariable ["AE3_CliElevateSudoers", true])
        && {[_computer, _user] call AE3_armaos_fnc_computer_isSudoer}
    };
private _fsUser = [_user, "root"] select _elevated;
private _path = _data getOrDefault ["path", "/"];

switch (_op) do {

    case "stat": {
        try {
            private _dir = [[], _fs, _path, _fsUser] call AE3_filesystem_fnc_getParentDir;
            private _current = (_dir select 1) select 0;
            private _name = _dir select 2;
            if (!(_name in _current)) throw "not_found";
            private _obj = _current get _name;
            [_obj, _fsUser, 0] call AE3_filesystem_fnc_hasPermission;
            _res set ["owner", _obj select 1];
            _res set ["permissions", _obj select 2];
            _res set ["dir", (_obj select 0) isEqualType createHashMap];
        } catch {
            _res set ["error", "denied"];
        };
    };

    case "chmod": {
        private _permissions = _data getOrDefault ["permissions", []];
        private _recursive = _data getOrDefault ["recursive", false];
        if !(_permissions isEqualType [] && {count _permissions == 2}) exitWith { _res set ["error", "bad_input"]; };
        try {
            private _chmodUser = [_user, "root"] select _elevated;
            [[], _fs, _path, _chmodUser, _permissions, _recursive] call AE3_filesystem_fnc_chmod;
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    case "list": {
        private _entries = [];
        try {
            ([[], _fs, _path, _fsUser] call AE3_filesystem_fnc_chdir) params ["", "_dir"];
            [_dir, _fsUser, 0] call AE3_filesystem_fnc_hasPermission;
            private _content = _dir select 0;
            private _names = keys _content;
            _names sort true;
            {
                private _child = _content get _x;
                private _link = [(_child select 0)] call AE3_filesystem_fnc_symlinkTarget;
                private _isDir = (_child select 0) isEqualType createHashMap;
                // A symlink reports the target's kind so the GUI knows to navigate (dir) vs open (file)
                // vs launch (app launcher). Resolve the target's dir-ness best-effort.
                if (_link isNotEqualTo "") then {
                    _isDir = false;
                    try {
                        ([[], _fs, _link, _fsUser] call AE3_filesystem_fnc_chdir) params ["", "_ld"];
                        _isDir = (_ld select 0) isEqualType createHashMap;
                    } catch {};
                };
                // An executable file carries a code payload (the programs under /bin etc.); the GUI
                // tints these green and runs them on double-click via the terminal. A symlink is
                // executable when the file it points at is - resolve the target's content type.
                private _isExec = false;
                if (!_isDir) then {
                    if (_link isNotEqualTo "") then {
                        try {
                            private _targetContent = [[], _fs, _link, _fsUser, 0] call AE3_filesystem_fnc_getFile;
                            _isExec = _targetContent isEqualType {};
                        } catch {};
                    } else {
                        _isExec = (_child select 0) isEqualType {};
                    };
                };
                _entries pushBack createHashMapFromArray [
                    ["name", _x],
                    ["dir", _isDir],
                    ["link", _link],
                    ["exec", _isExec]
                ];
            } forEach _names;
            _res set ["entries", _entries];
        } catch {
            _res set ["error", "denied"];
            _res set ["entries", []];
        };
    };

    case "read": {
        try {
            // Follow symlinks (depth-guarded) so opening a link reads its target.
            private _rpath = _path;
            private _content = "";
            for "_i" from 0 to 16 do {
                _content = [[], _fs, _rpath, _fsUser, 0] call AE3_filesystem_fnc_getFile;
                private _lt = [_content] call AE3_filesystem_fnc_symlinkTarget;
                if (_lt isEqualTo "") exitWith {};
                if (_i isEqualTo 16) throw "symlink_loop";
                _rpath = _lt;
            };
            if (_content isEqualType "") then {
                // Password-protected file: report it as locked WITHOUT shipping the password or payload
                // to the browser. The app prompts for the password and verifies via "unlock". The
                // raw "AE3_LOCKED|len|.." string must never reach the UI (the old leak).
                ([_content] call AE3_armaos_fnc_shell_parseLockedFile) params ["_locked", "", "_payload"];
                if (_locked) then { _res set ["locked", true]; }
                else { _res set ["content", _content]; };
                if (AE3_DebugMode && {(_content select [0, 10]) isEqualTo "AE3_MEDIA|"}) then {
                    diag_log format ["[AE3 DEBUG] [%1] fsHandle read media marker at %2: %3", time, _path, _content];
                };
            }
            else { _res set ["error", "not_text"]; };
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Verify the password for a locked file server-trusted and return the payload only on a match.
    // Wrong attempts are logged to /var/log/auth.log on the server (mirrors fnc_os_unlock).
    case "unlock": {
        private _pass = _data getOrDefault ["pass", ""];
        try {
            private _content = [[], _fs, _path, _fsUser, 0] call AE3_filesystem_fnc_getFile;
            ([_content] call AE3_armaos_fnc_shell_parseLockedFile) params ["_locked", "_correct", "_payload"];
            if (_locked) then {
                if (_pass isEqualTo _correct) then { _res set ["content", _payload]; }
                else {
                    _res set ["error", "bad_pass"];
                    [_computer, "System", format ["unlock: wrong password for '%1' (desktop)", _path], "/var/log/auth.log"] remoteExec ["AE3_armaos_fnc_shell_writeToLogfile", 2];
                };
            } else { _res set ["content", _content]; };
        } catch {
            _res set ["error", "denied"];
        };
    };

    case "save": {
        private _content = _data getOrDefault ["content", ""];
        try {
            [[], _fs, _path, "", _fsUser, _user, [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
            [[], _fs, _path, _fsUser, _content, false] call AE3_filesystem_fnc_writeToFile;
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    case "mkdir": {
        try {
            [[], _fs, _path, _fsUser, _user] call AE3_filesystem_fnc_ensureDir;
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Delete now moves to the Recycle Bin (/.trash) instead of destroying the object. A name
    // clash in the bin is resolved with a numeric suffix so repeated deletes never overwrite.
    case "delete": {
        try {
            // The bin is root's and writable by everyone: a delete is a move into it, and the mover needs
            // write on the target directory. Creating it as the deleting user would fail outright (the root
            // directory is not world-writable) and would lock every other account out of the bin it made.
            private _created = [[], _fs, "/.trash", "root", "root", [[true, true, true], [true, true, true]]] call AE3_filesystem_fnc_ensureDir;
            if (!_created) then {
                // A bin carried over from a device initialized before this may still be owner-only; opening
                // it back up keeps a delete from failing on a directory the account cannot write to.
                [[], _fs, "/.trash", "root", [[true, true, true], [true, true, true]]] call AE3_filesystem_fnc_chmod;
            };
            private _parts = _path splitString "/";
            private _name = _parts param [(count _parts) - 1, ""];
            private _trashName = _name;
            private _target = "/.trash/" + _name;
            private _i = 1;
            while { [[], _fs, _target, _fsUser] call AE3_filesystem_fnc_fsObjExists } do {
                _trashName = format ["%1.%2", _name, _i];
                _target = "/.trash/" + _trashName; _i = _i + 1;
            };
            [[], _fs, _path, _target, _fsUser, false] call AE3_filesystem_fnc_mvObj;
            // Remember where it came from so Restore can return it to the original location.
            private _meta = _computer getVariable ["AE3_trash_meta", createHashMap];
            _meta set [_trashName, _path];
            _computer setVariable ["AE3_trash_meta", _meta, 2];
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Cut/paste (move) and copy/paste for the right-click context menu. _data: path=source, dest=target.
    case "move";
    case "copy": {
        private _dest = _data getOrDefault ["dest", ""];
        if (_dest isEqualTo "") exitWith { _res set ["error", "bad_input"]; };
        try {
            [[], _fs, _path, _dest, _fsUser, (_op isEqualTo "copy")] call AE3_filesystem_fnc_mvObj;
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Recycle Bin restore: move an item out of /.trash back to its ORIGINAL location. If the
    // original is unknown (deleted before this tracking existed) fall back to the user's home. When a
    // file already exists at the destination, report needsConfirm and wait for an overwrite:true retry.
    case "restore": {
        private _name = _data getOrDefault ["name", ""];
        private _overwrite = _data getOrDefault ["overwrite", false];
        if (_name isEqualTo "") exitWith { _res set ["error", "bad_input"]; };
        private _meta = _computer getVariable ["AE3_trash_meta", createHashMap];
        // a sudoer keeps their own home; only the root/admin accounts live in /root
        private _home = [format ["/home/%1", _user], "/root"] select (_user in ["root", "admin"]);
        private _dest = _meta getOrDefault [_name, _home + "/" + _name];
        try {
            if (!_overwrite && {[[], _fs, _dest, _fsUser] call AE3_filesystem_fnc_fsObjExists}) exitWith {
                _res set ["needsConfirm", true];
                _res set ["dest", _dest];
            };
            if (_overwrite && {[[], _fs, _dest, _fsUser] call AE3_filesystem_fnc_fsObjExists}) then {
                [[], _fs, _dest, _fsUser] call AE3_filesystem_fnc_delObj;
            };
            [[], _fs, "/.trash/" + _name, _dest, _fsUser, false] call AE3_filesystem_fnc_mvObj;
            _meta deleteAt _name;
            _computer setVariable ["AE3_trash_meta", _meta, 2];
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Permanently delete a single Recycle Bin item. _data: name (relative to /.trash).
    case "purge": {
        private _name = _data getOrDefault ["name", ""];
        if (_name isEqualTo "") exitWith { _res set ["error", "bad_input"]; };
        try {
            [[], _fs, "/.trash/" + _name, _fsUser] call AE3_filesystem_fnc_delObj;
            private _meta = _computer getVariable ["AE3_trash_meta", createHashMap];
            if (_name in _meta) then { _meta deleteAt _name; _computer setVariable ["AE3_trash_meta", _meta, 2]; };
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Empty the Recycle Bin: permanently drop /.trash and recreate it empty.
    case "empty_trash": {
        try {
            if ([[], _fs, "/.trash", _fsUser] call AE3_filesystem_fnc_fsObjExists) then {
                [[], _fs, "/.trash", _fsUser] call AE3_filesystem_fnc_delObj;
            };
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Create a symbolic link: _data path=link location, target=absolute target path.
    case "symlink": {
        private _target = _data getOrDefault ["target", ""];
        if (_target isEqualTo "") exitWith { _res set ["error", "bad_input"]; };
        try {
            [[], _fs, _path, _target, _fsUser, _user] call AE3_filesystem_fnc_symlink;
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "denied"];
        };
    };

    // Recursive, case-insensitive glob search. _data: query (with optional "*"), root.
    case "search": {
        private _query = _data getOrDefault ["query", ""];
        private _root = _data getOrDefault ["root", "/"];
        if (_query isEqualTo "") exitWith { _res set ["error", "bad_input"]; _res set ["results", []]; };
        // Translate the user glob to a lowercased, fully-anchored regex: escape regex metacharacters,
        // then turn the escaped "*" back into ".*". Bare text (no "*") matches as a substring.
        private _q = toLower _query;
        if !("*" in _q) then { _q = "*" + _q + "*"; };
        private _rx = "";
        for "_i" from 0 to (count _q - 1) do {
            private _c = _q select [_i, 1];
            if (_c in ["\", ".", "^", "$", "+", "?", "(", ")", "[", "]", "{", "}", "|"]) then { _rx = _rx + "\" + _c; }
            else { if (_c isEqualTo "*") then { _rx = _rx + ".*"; } else { _rx = _rx + _c; }; };
        };
        private _hits = [];
        try {
            ([[], _fs, _root, _fsUser] call AE3_filesystem_fnc_chdir) params ["_rootPntr", "_rootDir"];
            private _found = [_rootPntr, _rootDir, _fsUser, _rx] call AE3_filesystem_fnc_searchFilesystem;
            {
                _x params ["_p", "_d"];
                _hits pushBack createHashMapFromArray [["path", _p], ["dir", _d]];
            } forEach _found;
            _res set ["results", _hits];
        } catch {
            _res set ["error", "denied"];
            _res set ["results", []];
        };
    };

    default { _res set ["error", "bad_op"]; };
};

_res
