// File: fnc_routerHandle.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Backs the in-browser router admin page. Reads and writes the settings of the
 * router this laptop is connected to (its gateway): network name (ace_cargo_customName, shown by the
 * Network app's scan), wireless range, and password. Any client connected to the router may view/edit
 * it - mirroring a real consumer router whose web UI is reachable from the LAN. Writes are applied
 * server-side and broadcast.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop
 * 1: _op <STRING> - "get" | "set"
 * 2: _data <HASHMAP> - for "set": keys name, range, password
 *
 * Return Value:
 * Result <HASHMAP>
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_op", "", [""]], ["_data", createHashMap, [createHashMap]]];

private _res = createHashMapFromArray [["error", ""]];
if (isNull _computer) exitWith { _res set ["error", "no_device"]; _res };

private _router = _computer getVariable ["AE3_network_parent", objNull];
if (isNull _router) exitWith { _res set ["error", "not_connected"]; _res };

switch (_op) do {

    case "get": {
        _res set ["name", ([_router] call AE3_main_fnc_getDeviceName)];
        _res set ["range", _router getVariable ["AE3_network_wirelessRange", 100]];
        _res set ["password", _router getVariable ["AE3_network_password", ""]];
        _res set ["gateway", ([_router getVariable ["AE3_network_address", [192, 168, 0, 1]]] call AE3_network_fnc_ip2str)];
        _res set ["extSsh", _router getVariable ["AE3_network_allowExternalSsh", false]];
        _res set ["extAllow", _router getVariable ["AE3_network_externalAllow", ""]];
    };

    case "set": {
        private _name = _data getOrDefault ["name", ""];
        private _range = _data getOrDefault ["range", 0];
        if !(_range isEqualType 0) then { _range = parseNumber (str _range); };
        private _password = _data getOrDefault ["password", ""];
        private _gateway = _data getOrDefault ["gateway", ""]; // "a.b.c.d", blank = unchanged
        private _extSsh = _data getOrDefault ["extSsh", false];
        private _extAllow = _data getOrDefault ["extAllow", ""];
        // Apply on the server (router is server-owned) and broadcast so scans/connects see it.
        [_router, _name, _range, _password, _gateway, _extSsh, _extAllow] remoteExecCall ["AE3_network_fnc_applyRouterConfig", 2];
        _res set ["ok", true];
    };

    default { _res set ["error", "bad_op"]; };
};

_res
