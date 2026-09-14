// File: fnc_jsRouter.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: JS->SQF bridge / command dispatcher for the web desktop (WS-B). Bound as the
 * "JSDialog" event handler of the type-106 browser control. The HTML/JS side calls A3.send /
 * A3.request, which raise JSDialog with a JSON string {command, rid, data}. This is the single
 * choke point for all web-app commands: it decodes the request, dispatches to the relevant AE3
 * backend, and (for A3.request) replies via AE3_desktop_fnc_jsSend, echoing the rid so the JS
 * Promise resolves. Keeps the network surface to one EH per client.
 *
 * Arguments:
 * 0: _control <CONTROL> - The browser control that raised the event
 * 1: _isConfirm <BOOL> - true if the JS side used confirm(), false for alert()
 * 2: _message <STRING> - The raw JSON payload string sent from JS
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Public: No
 */

params [["_control", controlNull, [controlNull]], ["_isConfirm", false, [false]], ["_message", "", [""]]];

if (_message isEqualTo "") exitWith { true };

// _objectType 2 = native hash map. The default (0) returns a CBA namespace (LOCATION), which fails
// the isEqualType check below and the getOrDefault/hashmap reads throughout this dispatcher.
private _req = [_message, 2] call CBA_fnc_parseJSON;
if (isNil "_req" || {!(_req isEqualType createHashMap)}) exitWith {
    diag_log text format ["[AE3 desktop] unparseable JS payload: %1", _message];
    true
};

private _command = _req getOrDefault ["command", ""];
private _rid = _req getOrDefault ["rid", ""];
private _data = _req getOrDefault ["data", createHashMap];
if !(_data isEqualType createHashMap) then { _data = createHashMap; };

private _display = ctrlParent _control;
private _computer = _display getVariable [QGVAR(computer), objNull];

if ((missionNamespace getVariable [QGVAR(debug), false]) || {missionNamespace getVariable ["AE3_DebugMode", false]}) then {
    systemChat format ["[AE3] JS: %1", _command];
    diag_log text format ["[AE3 desktop] JS->SQF '%1' rid=%2 data=%3", _command, _rid, _data];
};

// Reply helper: only sends when the JS side used A3.request (has a rid).
private _reply = {
    params ["_payload"];
    if (_rid isEqualTo "") exitWith {};
    [_command, createHashMapFromArray [["_rid", _rid], ["data", _payload]]] call FUNC(jsSend);
};

switch (_command) do {

    // Switch this laptop from the GUI desktop to the CLI terminal (the "Terminal" dock/menu app).
    // Gated by the same interface-access model as the ACE "Use Terminal" action; when CLI access is
    // denied the request is a no-op. Closes the web desktop and opens the terminal holding the mutex.
    case "sys_switch_cli": {
        if (isNull _computer) exitWith {};
        private _allowed = if (isNil "AE3_desktop_fnc_canAccessInterface") then { true } else {
            [_computer, player, "cli"] call FUNC(canAccessInterface)
        };
        if (!_allowed) exitWith {};

        _display closeDisplay 0;
        [{
            params ["_computer"];
            _computer setVariable ["AE3_computer_mutex", player, true];
            [_computer] spawn AE3_armaos_fnc_terminal_init;
        }, [_computer]] call CBA_fnc_execNextFrame;
    };

    // Run an executable file (double-clicked in the Files app / desktop) as an .app would: CLI
    // programs need a terminal, so switch to the CLI and execute the file once a session is active.
    // Gated by CLI access; if the terminal is never authenticated the run quietly times out.
    case "sys_run_file": {
        if (isNull _computer) exitWith {};
        private _path = _data getOrDefault ["path", ""];
        if (_path isEqualTo "") exitWith {};
        private _allowed = if (isNil "AE3_desktop_fnc_canAccessInterface") then { true } else {
            [_computer, player, "cli"] call FUNC(canAccessInterface)
        };
        if (!_allowed) exitWith {};

        _display closeDisplay 0;
        [{
            params ["_computer", "_path"];
            _computer setVariable ["AE3_computer_mutex", player, true];
            [_computer] spawn AE3_armaos_fnc_terminal_init;
            [
                {
                    params ["_computer", "_path"];
                    private _terminal = _computer getVariable ["AE3_terminal", nil];
                    !isNil "_terminal" && {(_terminal getOrDefault ["AE3_terminalLoginUser", ""]) isNotEqualTo ""}
                },
                { params ["_computer", "_path"]; [_computer, _path, []] spawn AE3_armaos_fnc_shell_executeFile; },
                [_computer, _path],
                10
            ] call CBA_fnc_waitUntilAndExecute;
        }, [_computer, _path]] call CBA_fnc_execNextFrame;
    };

    // UI is up: seed the hostname only (does NOT skip login - the user still authenticates via
    // "login"). Auto-login, when wanted, is a separate explicit "boot" push.
    case "ready": {
        if (!isNull _computer) then {
            private _host = _computer getVariable ["ace_cargo_customName", "armaOS"];
            ["hostname", createHashMapFromArray [["hostname", _host]]] call FUNC(jsSend);
            ["ae3_desktop_ready", [_computer]] call CBA_fnc_localEvent;
        };
        // Push apps registered by other addons into the launcher. Apps can require a laptop object
        // variable so addon-specific tools only appear where they were installed.
        private _ext = missionNamespace getVariable [QGVAR(extApps), []];
        if (_ext isNotEqualTo []) then {
            private _filtered = _ext select {
                private _extra = _x getOrDefault ["extra", createHashMap];
                private _requires = _extra getOrDefault ["requiresVar", []];
                private _varOk = (_requires isEqualTo []) || {
                    _requires params [["_varName", ""], ["_expected", true]];
                    _varName isNotEqualTo "" && {(_computer getVariable [_varName, "__AE3_missing__"]) isEqualTo _expected}
                };
                private _requiresFunction = _extra getOrDefault ["requiresFunction", ""];
                private _fnOk = (_requiresFunction isEqualTo "") || {
                    private _fn = missionNamespace getVariable [_requiresFunction, {}];
                    (_fn isEqualType {}) && {[_computer] call _fn}
                };
                _varOk && _fnOk
            };
            ["ext_apps", _filtered] call FUNC(jsSend);
        };
        // Seamless re-entry: if the laptop still has an active session (the previous user did
        // NOT sign out), auto-resume that session instead of demanding the password again. Anyone who
        // opens the laptop continues where it was left.
        if (!isNull _computer) then {
            private _session = _computer getVariable [QGVAR(sessionUser), ""];
            // Only auto-resume the stored session for the SAME player who left it signed in. A
            // different player must authenticate, so they operate as their own user and are bound by
            // that user's filesystem permissions instead of inheriting the previous user's access.
            private _sessionOwner = _computer getVariable [QGVAR(sessionOwner), ""];
            if (_session isNotEqualTo "" && {_sessionOwner isEqualTo (getPlayerUID player)}) then {
                _display setVariable [QGVAR(user), _session];
                private _host = _computer getVariable ["ace_cargo_customName", "armaOS"];
                ["boot", createHashMapFromArray [["user", _session], ["hostname", _host]]] call FUNC(jsSend);
            };
        };
    };

    // Login against the synced user list. The common case (account already cached by the open-time
    // background sync in desktop_openWeb) is answered immediately. When the account is not yet in
    // this client's cached userlist - a Zeus "Add User" or a Restore Laptop applied after this
    // client synced - the verdict is resolved off-thread: the userlist is pulled authoritatively
    // (a blocking round-trip in the scheduled context) and re-checked with a definitive answer, so
    // login never loops on "retry" indefinitely.
    case "login": {
        private _user = _data getOrDefault ["user", ""];
        private _pass = _data getOrDefault ["pass", ""];

        // Persists a successful session on the laptop so closing/reopening resumes without re-login,
        // tagged with this player so only they get the seamless re-entry (see "ready"). Everything it
        // touches is taken as an argument: the retry path below calls it from inside a spawn, which
        // starts a fresh variable scope where the caller's locals do not exist.
        private _persistSession = {
            params ["_res", "_sessionDisplay", "_sessionUser", "_sessionComputer"];
            if (_res getOrDefault ["ok", false]) then {
                if (!isNull _sessionDisplay) then {
                    _sessionDisplay setVariable [QGVAR(user), _sessionUser];
                };
                if (!isNull _sessionComputer) then {
                    _sessionComputer setVariable [QGVAR(sessionUser), _sessionUser, true];
                    _sessionComputer setVariable [QGVAR(sessionOwner), getPlayerUID player, true];
                };
            };
        };

        private _res = [_computer, _user, _pass] call FUNC(authUser);
        if (_res getOrDefault ["retry", false]) then {
            // Cache miss: resolve authoritatively in a scheduled thread, then reply.
            [_computer, _user, _pass, _rid, _command, _persistSession, _display] spawn {
                params ["_computer", "_user", "_pass", "_rid", "_command", "_persistSession", "_display"];
                if (isMultiplayer && {!isNull _computer}) then {
                    [_computer, "AE3_Userlist"] call AE3_main_fnc_getRemoteVar; // blocks until synced
                };
                private _res = [_computer, _user, _pass, true] call AE3_desktop_fnc_authUser;
                [_res, _display, _user, _computer] call _persistSession;
                if (_rid isNotEqualTo "") then {
                    [_command, createHashMapFromArray [["_rid", _rid], ["data", _res]]] call AE3_desktop_fnc_jsSend;
                };
            };
        } else {
            [_res, _display, _user, _computer] call _persistSession;
            [_res] call _reply;
        };
    };

    // --- Filesystem (Files + Notepad), permission-scoped per logged-in user. ---
    case "fs_list";
    case "fs_read";
    case "fs_unlock";
    case "fs_save";
    case "fs_mkdir";
    case "fs_delete";
    case "fs_move";
    case "fs_copy";
    case "fs_symlink";
    case "fs_search";
    case "fs_restore";
    case "fs_purge";
    case "fs_empty_trash";
    case "fs_stat";
    case "fs_chmod": {
        private _user = _display getVariable [QGVAR(user), ""];
        private _op = _command select [3]; // strip "fs_"
        [[_computer, _user, _op, _data] call FUNC(fsHandle)] call _reply;
    };
    // Open a media-marker file natively (image viewer / video / audio) via fnc_openFile. Images reach
    // here as the native RscPicture fallback after the in-OS web viewer could not display them.
    case "fs_open_media": {
        if (AE3_DebugMode) then { diag_log format ["[AE3 DEBUG] [%1] fs_open_media native handoff: path=%2 content=%3", time, _data getOrDefault ["path", ""], _data getOrDefault ["content", ""]]; };
        [_computer, _data getOrDefault ["path", ""], _data getOrDefault ["content", ""], _data getOrDefault ["rect", []]] call FUNC(openFile);
    };

    // --- Network + system info. ---
    // My Computer volumes: list/mount/unmount USB drives.
    case "vol_list";
    case "vol_connect";
    case "vol_mount";
    case "vol_eject";
    case "vol_unmount": {
        private _user = _display getVariable [QGVAR(user), ""];
        private _op = _command select [4]; // strip "vol_"
        [[_computer, _user, _op, _data] call FUNC(volHandle)] call _reply;
    };

    // Resolve a map grid reference typed by the user into a world position, so an app can measure
    // distances from that grid square instead of from the player. Only the engine knows the map's
    // grid layout, so JS cannot do this on its own. An unparseable grid replies with ok = false.
    case "grid_pos": {
        private _grid = toUpper (_data getOrDefault ["grid", ""]);
        private _digits = count (toArray _grid);
        private _res = createHashMapFromArray [["ok", false], ["pos", []]];
        if (_grid regexMatch "^\d+$" && _digits >= 2 && {_digits % 2 == 0} && _digits <= 10) then {
            // true = centre of the grid square, so the radius is measured from the middle of the
            // square the operator named rather than its top-left corner.
            _res set ["pos", [_grid, true] call CBA_fnc_mapGridToPos];
            _res set ["ok", true];
        };
        [_res] call _reply;
    };

    case "net_scan": { [[_computer] call FUNC(netScan)] call _reply; };
    case "sysinfo":  { [[_computer, _display getVariable [QGVAR(user), ""]] call FUNC(sysInfo)] call _reply; };
    // Calendar intel events. The store (AE3_calendar_events) is broadcast by the server, so the
    // client reads it locally and the JS app caches the whole set on open. Returns every
    // event as {date,title,location,body,index}; the app filters per month client-side.
    case "cal_list": {
        private _events = _computer getVariable ["AE3_calendar_events", []];
        private _out = [];
        {
            _x params [["_date", ""], ["_title", ""], ["_loc", ""], ["_body", ""], ["_time", ""]];
            _out pushBack createHashMapFromArray [
                ["date", _date], ["title", _title], ["location", _loc], ["body", _body], ["time", _time], ["index", _forEachIndex]
            ];
        } forEach _events;
        [_out] call _reply;
    };
    case "cal_add": {
        private _ares = createHashMapFromArray [["error", ""]];
        private _date = _data getOrDefault ["date", ""];
        private _title = _data getOrDefault ["title", ""];
        if (isNull _computer || {_date isEqualTo "" || _title isEqualTo ""}) then { _ares set ["error", "bad_input"]; }
        else {
            [_computer, _date, _title, _data getOrDefault ["location", ""], _data getOrDefault ["body", ""], _data getOrDefault ["time", ""]] remoteExec ["AE3_armaos_fnc_computer_addCalendarEvent", 2];
            _ares set ["ok", true];
        };
        [_ares] call _reply;
    };
    case "cal_delete": {
        private _dres = createHashMapFromArray [["error", ""]];
        private _idx = _data getOrDefault ["index", -1];
        if (isNull _computer || _idx < 0) then { _dres set ["error", "bad_input"]; }
        else {
            [_computer, _idx] remoteExec ["AE3_armaos_fnc_computer_removeCalendarEvent", 2];
            _dres set ["ok", true];
        };
        [_dres] call _reply;
    };

    // In-window minimap data.
    case "map_data": { [[_computer, _data] call FUNC(mapData)] call _reply; };

    // Native real-world map overlay: CEF cannot host the map control, so open it as a dialog.
    case "map_open": { [_computer, _data] call FUNC(mapOpen); };

    // Settings: change system name / wallpaper, applied server-side and broadcast. Wallpaper is
    // stored per logged-in user so different users of the same laptop keep their own.
    case "sys_set": {
        private _sres = createHashMapFromArray [["error", ""]];
        if (isNull _computer) then { _sres set ["error", "no_device"]; }
        else {
            [_computer, _data getOrDefault ["hostname", ""], _data getOrDefault ["wallpaper", ""], _display getVariable [QGVAR(user), ""]] remoteExec ["AE3_desktop_fnc_setSystemConfig", 2];
            _sres set ["ok", true];
        };
        [_sres] call _reply;
    };

    // Selectable wallpapers: the bundled images plus any registered via registerMedia. The bundled
    // ones are served as pre-encoded base64 sidecars (.png.b64) so the CEF surface reads them via
    // RequestFile instead of the unreliable .paa texture sampler; the Settings app turns each into a
    // data URL through the bridge.
    case "wallpaper_list": {
        private _list = [
            "\z\ae3\addons\desktop\images\wallpaper_1.png.b64",
            "\z\ae3\addons\desktop\images\wallpaper_2.png.b64",
            "\z\ae3\addons\desktop\images\wallpaper_3.png.b64",
            "\z\ae3\addons\desktop\images\wallpaper_4.png.b64",
            "\z\ae3\addons\desktop\images\wallpaper_5.png.b64",
            "\z\ae3\addons\desktop\images\do-u-code-bro.png.b64"
        ];
        // Only offer registered images the CEF surface can actually render: a base64 sidecar (either
        // the path itself or a "<path>.b64" companion). A raw mission raster/paa without a sidecar
        // cannot be a web wallpaper and would only make the Settings thumbnail loader trip the engine
        // "Script ....b64 not found" / "Unknown sampler texture type" warnings, so it is filtered out
        // here (it can still be opened in the native image viewer).
        {
            private _entry = _x;
            private _b64 = if ((toLower _entry) select [(count _entry) - 4] isEqualTo ".b64") then { _entry } else { _entry + ".b64" };
            if (fileExists _b64) then { _list pushBackUnique _entry; };
        } forEach (missionNamespace getVariable ["AE3_Desktop_WallpaperList", []]);
        [createHashMapFromArray [["wallpapers", _list]]] call _reply;
    };

    // Mail.
    case "mail_list": { [[_computer, "list", _data] call FUNC(mailHandle)] call _reply; };
    case "mail_sent_list": { [[_computer, "list_sent", _data] call FUNC(mailHandle)] call _reply; };
    case "mail_read": { [[_computer, "read", _data] call FUNC(mailHandle)] call _reply; };
    case "mail_read_sent": { [[_computer, "read_sent", _data] call FUNC(mailHandle)] call _reply; };
    case "mail_delete": { [[_computer, "delete", _data] call FUNC(mailHandle)] call _reply; };
    case "addr_list": {
        private _addresses = [];
        if (!isNull _computer) then {
            private _netId = netId _computer;
            private _registry = missionNamespace getVariable ["AE3_mail_addresses", createHashMap];
            {
                private _entry = _registry get _x;
                if ((_entry param [0, ""]) isEqualTo _netId || { (_entry param [0, ""]) isEqualTo "" }) then { _addresses pushBack (_entry param [1, _x]); };
            } forEach (keys _registry);
            _addresses sort true;
        };
        [createHashMapFromArray [["addresses", _addresses]]] call _reply;
    };
    case "addr_create": {
        if (isNull _computer) exitWith { [createHashMapFromArray [["error", "no_device"]]] call _reply; };
        ["ae3_desktop_addrRegister", [clientOwner, _rid, netId _computer, _data getOrDefault ["address", ""]]] call CBA_fnc_serverEvent;
    };
    case "addr_delete": {
        if (isNull _computer) exitWith { [createHashMapFromArray [["error", "no_device"]]] call _reply; };
        ["ae3_desktop_addrRelease", [clientOwner, _rid, netId _computer, _data getOrDefault ["address", ""]]] call CBA_fnc_serverEvent;
    };
    case "mail_send": {
        if (isNull _computer) exitWith { [createHashMapFromArray [["error", "no_device"]]] call _reply; };
        ["ae3_desktop_mailRoute", [
            clientOwner, _rid, netId _computer,
            _data getOrDefault ["from", ""],
            _data getOrDefault ["to", ""],
            _data getOrDefault ["subject", ""],
            _data getOrDefault ["body", ""]
        ]] call CBA_fnc_serverEvent;
    };

    // Browser: registered intel webpages and history file.
    case "web_pages": {
        private _pages = missionNamespace getVariable ["AE3_Desktop_Webpages", createHashMap];
        if (!isNull _computer) then
        {
            private _localPages = _computer getVariable ["AE3_Desktop_Webpages", createHashMap];
            {
                _pages set [_x, _localPages get _x];
            } forEach (keys _localPages);
        };
        private _pageOut = [];
        {
            private _entry = _pages get _x;
            _pageOut pushBack createHashMapFromArray [["url", _x], ["title", _entry select 0], ["content", _entry select 1]];
        } forEach (keys _pages);
        [createHashMapFromArray [["pages", _pageOut]]] call _reply;
    };

    // Registered custom domains -> mission site-root folders (AE3_desktop_fnc_registerSite). Merged
    // global + per-laptop, returned as {domain: siteRoot} so the Browser can resolve typed domains
    // and route in-page links under them.
    case "web_sites": {
        private _sites = +(missionNamespace getVariable ["AE3_Desktop_Sites", createHashMap]);
        if (!isNull _computer) then
        {
            private _localSites = _computer getVariable ["AE3_Desktop_Sites", createHashMap];
            {
                _sites set [_x, _localSites get _x];
            } forEach (keys _localSites);
        };
        private _siteOut = createHashMap;
        {
            _siteOut set [_x, _sites get _x];
        } forEach (keys _sites);
        [createHashMapFromArray [["sites", _siteOut]]] call _reply;
    };
    case "web_history": {
        private _whres = createHashMapFromArray [["history", ""]];
        if (!isNull _computer) then
        {
            private _fs = _computer getVariable ["AE3_filesystem", []];
            if (_fs isNotEqualTo []) then
            {
                try
                {
                    private _hist = [[], _fs, "/var/log/browser_history", "root", 0] call AE3_filesystem_fnc_getFile;
                    if (_hist isEqualType "") then { _whres set ["history", _hist]; };
                }
                catch {};
            };
        };
        [_whres] call _reply;
    };
    case "web_log": {
        if (!isNull _computer) then
        {
            private _url = _data getOrDefault ["url", ""];
            if (_url isNotEqualTo "") then
            {
                private _fs = _computer getVariable ["AE3_filesystem", []];
                if (_fs isNotEqualTo []) then
                {
                    try
                    {
                        [[], _fs, "/var/log/browser_history", "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
                        [[], _fs, "/var/log/browser_history", "root", format ["[%1] %2%3", [dayTime, "HH:MM"] call BIS_fnc_timeToString, _url, endl], true] call AE3_filesystem_fnc_writeToFile;
                        _computer setVariable ["AE3_filesystem", _fs, 2];
                    }
                    catch {};
                };
            };
        };
    };

    // Messenger: pull live threads and route messages by registered handle.
    case "handle_list": {
        private _handles = [];
        if (!isNull _computer) then {
            private _netId = netId _computer;
            private _registry = missionNamespace getVariable ["AE3_msg_handles", createHashMap];
            {
                private _entry = _registry get _x;
                if ((_entry param [0, ""]) isEqualTo _netId) then { _handles pushBack (_entry param [1, _x]); };
            } forEach (keys _registry);
            _handles sort true;
        };
        [createHashMapFromArray [["handles", _handles]]] call _reply;
    };
    case "handles_all": {
        private _allHandles = [];
        private _ownNetId = if (isNull _computer) then { "" } else { netId _computer };
        private _hregistry = missionNamespace getVariable ["AE3_msg_handles", createHashMap];
        {
            private _hentry = _hregistry get _x;
            if ((_hentry param [0, ""]) isNotEqualTo _ownNetId) then
            {
                _allHandles pushBack createHashMapFromArray [["handle", _x], ["display", _hentry param [1, _x]]];
            };
        } forEach (keys _hregistry);
        [createHashMapFromArray [["handles", _allHandles]]] call _reply;
    };
    case "handle_create": {
        if (isNull _computer) exitWith { [createHashMapFromArray [["error", "no_device"]]] call _reply; };
        ["ae3_desktop_handleRegister", [clientOwner, _rid, netId _computer, _data getOrDefault ["handle", ""]]] call CBA_fnc_serverEvent;
    };
    case "handle_delete": {
        if (isNull _computer) exitWith { [createHashMapFromArray [["error", "no_device"]]] call _reply; };
        ["ae3_desktop_handleRelease", [clientOwner, _rid, netId _computer, _data getOrDefault ["handle", ""]]] call CBA_fnc_serverEvent;
    };
    case "chat_pull": {
        if (!isNull _computer) then {
            ["ae3_desktop_chatPull", [clientOwner, netId _computer]] call CBA_fnc_serverEvent;
        };
    };
    case "chat_send": {
        if (isNull _computer) exitWith { [createHashMapFromArray [["error", "no_device"]]] call _reply; };
        ["ae3_desktop_msgRoute", [clientOwner, _rid, netId _computer, _data getOrDefault ["to", ""], _data getOrDefault ["text", ""], _data getOrDefault ["from", ""]]] call CBA_fnc_serverEvent;
    };

    // Router admin web page: view/edit the connected router's name/range/password.
    case "router_page": { [[_computer, "get", _data] call FUNC(routerHandle)] call _reply; };
    case "router_set":  { [[_computer, "set", _data] call FUNC(routerHandle)] call _reply; };

    // SSH access toggle for THIS device, set from Settings.
    case "ssh_config": {
        private _sres = createHashMapFromArray [["error", ""]];
        if (isNull _computer) then { _sres set ["error", "no_device"]; }
        else {
            // Named function rather than a remote-executed raw setVariable: raw commands need their
            // own exclusions to pass the remote execution filters used on dedicated servers.
            [_computer, _data getOrDefault ["enabled", false]] remoteExecCall ["AE3_network_fnc_setSshEnabled", 2];
            _sres set ["ok", true];
        };
        [_sres] call _reply;
    };

    case "ping_host": {
        private _targetIp = [_data getOrDefault ["to", ""]] call AE3_network_fnc_str2ip;
        private _pres = createHashMapFromArray [["error", ""]];
        if (isNull _computer || {_targetIp isEqualTo []}) exitWith { _pres set ["error", "bad_addr"]; [_pres] call _reply; };

        if (AE3_DebugMode || {missionNamespace getVariable ["AE3_NetworkDebugEnabled", false]}) then {
            diag_log text format ["[AE3][ROUTE] ping_host source=%1#%2 target=%3", _computer getVariable ["ace_cargo_customName", "?"], netId _computer, [_targetIp] call AE3_network_fnc_ip2str];
        };

        ([_computer, _targetIp] call AE3_network_fnc_resolve) params ["_target", "_routeLength"];
        if (isNull _target) exitWith { _pres set ["error", "no_route"]; [_pres] call _reply; };

        _pres set ["ok", true];
        _pres set ["host", _target getVariable ["ace_cargo_customName", "remote"]];
        _pres set ["routeLength", _routeLength];
        [_pres] call _reply;
    };

    // SSH client ops: connect + remote filesystem browse/copy. Resolve the target IP, then run
    // server-side (auth against the remote user list); the server replies async through routeReply.
    case "ssh_connect";
    case "ssh_ls";
    case "ssh_read";
    case "ssh_pull";
    case "ssh_push": {
        private _op = _command select [4]; // strip "ssh_"
        private _targetIp = [_data getOrDefault ["to", ""]] call AE3_network_fnc_str2ip;
        private _sres = createHashMapFromArray [["error", ""]];
        if (isNull _computer || {_targetIp isEqualTo []}) exitWith { _sres set ["error", "bad_addr"]; [_sres] call _reply; };

        if (AE3_DebugMode || {missionNamespace getVariable ["AE3_NetworkDebugEnabled", false]}) then {
            diag_log text format ["[AE3][ROUTE] ssh_%1 source=%2#%3 target=%4 user=%5", _op, _computer getVariable ["ace_cargo_customName", "?"], netId _computer, [_targetIp] call AE3_network_fnc_ip2str, _data getOrDefault ["user", ""]];
        };
        // The server resolves the target device from the IP (topology-agnostic) and replies async
        // via ae3_desktop_sshReply. Only plain strings are passed across the network event (no
        // HashMap) so the payload serializes reliably in multiplayer.
        private _opArgs = [
            _data getOrDefault ["path", ""],
            _data getOrDefault ["dest", ""],
            _data getOrDefault ["content", ""]
        ];
        ["ae3_desktop_sshOp", [clientOwner, _rid, netId _computer, _targetIp,
            _data getOrDefault ["user", ""], _data getOrDefault ["pass", ""], _op, _opArgs]] call CBA_fnc_serverEvent;
    };

    case "net_connect": {
        private _netId = _data getOrDefault ["netId", ""];
        if (_netId isNotEqualTo "" && {!isNull _computer}) then {
            private _router = objectFromNetId _netId;
            if (!isNull _router) then {
                // Pass the supplied wireless password + this client so the server can validate and
                // report success/failure back to the Network app.
                [_computer, _router, _data getOrDefault ["password", ""], clientOwner] remoteExec ["AE3_desktop_fnc_netConnectServer", 2];
            };
        };
    };

    case "net_disconnect": {
        if (!isNull _computer) then {
            [_computer] remoteExec ["AE3_desktop_fnc_netDisconnectServer", 2];
        };
    };

    case "net_setip": {
        private _sires = createHashMapFromArray [["error", ""]];
        if (isNull _computer) then { _sires set ["error", "no_device"]; }
        else
        {
            private _ipStr = _data getOrDefault ["ip", ""];
            ["ae3_desktop_setStaticIp", [clientOwner, _rid, netId _computer, _ipStr]] call CBA_fnc_serverEvent;
        };
        if (_sires getOrDefault ["error", ""] isNotEqualTo "") then { [_sires] call _reply; };
    };

    // Open-window layout persistence: store the desktop's window snapshot on the laptop so a
    // reopen (by anyone) resumes exactly where it was left. Broadcast so it survives JIP/relocality.
    case "ui_save": {
        if (!isNull _computer) then {
            _computer setVariable [QGVAR(uiState), _data getOrDefault ["state", []], true];
        };
    };
    case "ui_get": {
        private _state = [];
        if (!isNull _computer) then { _state = _computer getVariable [QGVAR(uiState), []]; };
        [createHashMapFromArray [["state", _state]]] call _reply;
    };

    // Ping/SSH connection history, stored per laptop and broadcast so it survives JIP/relocality.
    // Each entry is a HashMap kept by the apps (key/ip/user/host/...); SSH entries only carry a
    // password when the user chose to save credentials. Mirrors ui_save/ui_get.
    case "hist_get": {
        private _ph = [];
        private _sh = [];
        if (!isNull _computer) then {
            _ph = _computer getVariable [QGVAR(pingHistory), []];
            _sh = _computer getVariable [QGVAR(sshHistory), []];
        };
        [createHashMapFromArray [["ping", _ph], ["ssh", _sh]]] call _reply;
    };
    case "hist_add": {
        if (!isNull _computer) then {
            private _kind = _data getOrDefault ["kind", ""];
            private _entry = _data getOrDefault ["entry", createHashMap];
            private _var = [QGVAR(pingHistory), QGVAR(sshHistory)] select (_kind isEqualTo "ssh");
            private _list = +(_computer getVariable [_var, []]);
            // Move a repeat connection to the top instead of duplicating it.
            private _key = _entry getOrDefault ["key", ""];
            _list = _list select { (_x getOrDefault ["key", ""]) isNotEqualTo _key };
            _list = [_entry] + _list;
            if (count _list > 12) then { _list resize 12; };
            _computer setVariable [_var, _list, true];
        };
        [createHashMapFromArray [["ok", true]]] call _reply;
    };
    case "hist_clear": {
        if (!isNull _computer) then {
            private _kind = _data getOrDefault ["kind", ""];
            private _var = [QGVAR(pingHistory), QGVAR(sshHistory)] select (_kind isEqualTo "ssh");
            _computer setVariable [_var, [], true];
        };
        [createHashMapFromArray [["ok", true]]] call _reply;
    };

    // Sign out: drop the session user; the JS side re-shows the login overlay. The display
    // (and the laptop claim/mutex) stay - this is a user switch, not a shutdown.
    case "signout": {
        _display setVariable [QGVAR(user), ""];
        // Clear the persisted session + window layout: only an explicit Sign Out locks the
        // laptop again and starts the next login with a clean desktop.
        if (!isNull _computer) then {
            _computer setVariable [QGVAR(sessionUser), "", true];
            _computer setVariable [QGVAR(sessionOwner), "", true];
            _computer setVariable [QGVAR(uiState), [], true];
        };
    };

    // Shut down: close the desktop (the AE3_Desktop_BrowserDisplay onUnload restores the idle
    // texture, releases the mutex and clears the ACE "in use" state) then power the laptop off.
    case "shutdown": {
        if (!isNull _computer) then {
            [_computer] remoteExec ["AE3_armaos_fnc_computer_turnOff", 2];
        };
        _display closeDisplay 0;
    };

    default {
        // Extension commands registered by other addons via AE3_desktop_fnc_registerCmd.
        private _handlers = missionNamespace getVariable [QGVAR(cmdHandlers), createHashMap];
        if (_command in _handlers) then {
            private _user = _display getVariable [QGVAR(user), ""];
            [_computer, _user, _data, _rid, _command] call (_handlers get _command);
        } else {
            diag_log text format ["[AE3 desktop] unhandled JS command '%1': %2", _command, _message];
        };
    };
};

true
