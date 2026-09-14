// File: fnc_mailHandle.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Mail operations for the web desktop Mail app. Reads /var/mail from the
 * laptop's cached filesystem (planted by AE3_desktop_fnc_addEmail / Zeus) and parses the
 * From/Subject/body format. Sending is handled in the router (needs the network ping + server
 * event). Client-local read.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop
 * 1: _op <STRING> - "list" | "read" | "delete"
 * 2: _data <HASHMAP> - key "file" for read/delete
 *
 * Return Value:
 * Result <HASHMAP>
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_op", "", [""]], ["_data", createHashMap, [createHashMap]]];

private _res = createHashMapFromArray [["error", ""]];
if (isNull _computer) exitWith { _res set ["error", "no_device"]; _res };

private _fs = _computer getVariable ["AE3_filesystem", []];
if (_fs isEqualTo []) exitWith { _res set ["error", "fs_not_ready"]; _res };

private _parse = {
    params ["_content", "_file"];
    private _from = "";
    private _to = "";
    private _received = "";
    private _subject = _file;
    private _bodyStart = 0;
    private _lines = _content splitString endl;
    {
        if ((_x select [0, 9]) isEqualTo "Received:") then { _received = [_x select [9]] call CBA_fnc_trim; };
        if ((_x select [0, 5]) isEqualTo "From:") then { _from = [_x select [5]] call CBA_fnc_trim; };
        if ((_x select [0, 3]) isEqualTo "To:") then { _to = [_x select [3]] call CBA_fnc_trim; };
        if ((_x select [0, 8]) isEqualTo "Subject:") then { _subject = [_x select [8]] call CBA_fnc_trim; };
        // Consume the contiguous header block (and any blank separators) at the top
        // so the body never repeats the headers shown as styled fields.
        if (_bodyStart == _forEachIndex && {((_x select [0, 9]) isEqualTo "Received:") || {(_x select [0, 5]) isEqualTo "From:"} || {(_x select [0, 3]) isEqualTo "To:"} || {(_x select [0, 8]) isEqualTo "Subject:"} || {([_x] call CBA_fnc_trim) isEqualTo ""}}) then { _bodyStart = _forEachIndex + 1; };
    } forEach _lines;
    createHashMapFromArray [
        ["file", _file], ["from", _from], ["to", _to], ["received", _received], ["subject", _subject],
        ["body", (_lines select [_bodyStart]) joinString endl]
    ]
};

switch (_op) do {

    case "list": {
        private _items = [];
        try {
            ([[], _fs, "/var/mail", "root"] call AE3_filesystem_fnc_chdir) params ["", "_dir"];
            private _content = _dir select 0;
            private _names = keys _content;
            _names sort false; // newest filenames (timestamped) last; reversed below
            reverse _names;
            {
                private _entry = _content get _x;
                // Skip the legacy IM inbox if present - chat now lives in /var/chat.
                if ((_entry select 0) isEqualType "" && _x isNotEqualTo "inbox") then {
                    private _meta = [_entry select 0, _x] call _parse;
                    _meta set ["body", ""]; // list view: headers only
                    _items pushBack _meta;
                };
            } forEach _names;
        } catch {};
        _res set ["mails", _items];
    };

    case "read": {
        private _file = _data getOrDefault ["file", ""];
        try {
            private _content = [[], _fs, format ["/var/mail/%1", _file], "root", 0] call AE3_filesystem_fnc_getFile;
            if (_content isEqualType "") then {
                private _mail = [_content, _file] call _parse;
                { _res set [_x, _mail get _x]; } forEach (keys _mail);
            } else { _res set ["error", "not_text"]; };
        } catch {
            _res set ["error", "not_found"];
        };
    };

    case "list_sent": {
        private _items = [];
        try {
            ([[], _fs, "/var/sent", "root"] call AE3_filesystem_fnc_chdir) params ["", "_dir"];
            private _content = _dir select 0;
            private _sentNames = keys _content;
            _sentNames sort false;
            reverse _sentNames;
            {
                private _entry = _content get _x;
                if ((_entry select 0) isEqualType "") then {
                    private _meta = [_entry select 0, _x] call _parse;
                    _meta set ["body", ""];
                    _items pushBack _meta;
                };
            } forEach _sentNames;
        } catch {};
        _res set ["mails", _items];
    };

    // Read a sent email from /var/sent (mirrors "read" but uses the sent directory).
    case "read_sent": {
        private _file = _data getOrDefault ["file", ""];
        try {
            private _content = [[], _fs, format ["/var/sent/%1", _file], "root", 0] call AE3_filesystem_fnc_getFile;
            if (_content isEqualType "") then {
                private _mail = [_content, _file] call _parse;
                { _res set [_x, _mail get _x]; } forEach (keys _mail);
            } else { _res set ["error", "not_text"]; };
        } catch {
            _res set ["error", "not_found"];
        };
    };

    // Delete an email: drop the file from /var/mail and push the updated filesystem.
    case "delete": {
        private _file = _data getOrDefault ["file", ""];
        if (_file isEqualTo "") exitWith { _res set ["error", "bad_input"]; };
        try {
            [[], _fs, format ["/var/mail/%1", _file], "root"] call AE3_filesystem_fnc_delObj;
            _computer setVariable ["AE3_filesystem", _fs, 2];
            _res set ["ok", true];
        } catch {
            _res set ["error", "not_found"];
        };
    };

    default { _res set ["error", "bad_op"]; };
};

_res
