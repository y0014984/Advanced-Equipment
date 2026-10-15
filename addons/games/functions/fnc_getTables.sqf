// File: fnc_getTables.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Answers one device with its lobby: the tables it already holds a seat at, which is
 * what the front end offers as Continue, and the tables it could still join. Only tables reachable
 * from that device are listed, and no table's contents are included - a lobby never leaks a board or
 * a hand. Runs on the server; a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the asking device
 * 1: _gameId <STRING> (Optional) - Restrict the list to one game
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess"] call AE3_games_fnc_getTables;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_gameId", "", [""]]];

if (!isServer) exitWith {["ae3_games_list", [_deviceNetId, _gameId]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _owner = [_device] call FUNC(operatorOwner);

if (_owner <= 0) exitWith {};

private _enabled = [_device, "Enabled"] call FUNC(getSetting);
private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];

private _mine = [];
private _open = [];

if (_enabled) then
{
    {
        private _tableId = _x;
        private _table = _y;
        private _rowGame = _table getOrDefault ["gameId", ""];

        if (_gameId isEqualTo "" || (_rowGame isEqualTo _gameId)) then
        {
            private _info = [_rowGame] call FUNC(gameInfo);

            if (_info isNotEqualTo []) then
            {
                _info params ["", "", "_maxSeats", "_title"];

                private _seats = _table getOrDefault ["seats", []];
                private _host = objectFromNetId (_table getOrDefault ["host", ""]);

                private _row = createHashMapFromArray
                [
                    ["id", _tableId],
                    ["gameId", _rowGame],
                    ["title", _title],
                    // The name the host typed, if any; the front end falls back to the title
                    ["name", _table getOrDefault ["name", ""]],
                    ["phase", _table getOrDefault ["phase", "lobby"]],
                    ["seated", count _seats],
                    ["seatCount", _maxSeats],
                    ["turn", _table getOrDefault ["turn", 0]],
                    ["host", [_host] call FUNC(deviceLabel)],
                    ["seats", _seats apply
                    {
                        _x params ["_seatDeviceNetId", "_seatIndex", ["_seatLabel", ""]];

                        private _label = _seatLabel;

                        if (_label isEqualTo "") then {_label = [objectFromNetId _seatDeviceNetId] call FUNC(deviceLabel)};

                        [_seatIndex, _label]
                    }]
                ];

                if (([_table, _deviceNetId] call FUNC(seatOf)) >= 0) then
                {
                    _row set ["seat", [_table, _deviceNetId] call FUNC(seatOf)];
                    _mine pushBack _row;
                }
                else
                {
                    // Only offer a seat at a table this device can actually reach and that has room
                    if (count _seats < _maxSeats && {[_device, _host] call FUNC(reachable)}) then
                    {
                        _open pushBack _row;
                    };
                };
            };
        };
    } forEach _tables;
};

private _payload = createHashMapFromArray
[
    ["kind", "lobby"],
    ["device", _deviceNetId],
    ["gameId", _gameId],
    ["enabled", _enabled],
    ["canHost", _enabled && {[_device, "AllowHosting"] call FUNC(getSetting)}],
    ["graphical", [_device, "GraphicalUI"] call FUNC(getSetting)],
    ["debugSeats", [_device, "DebugSeats"] call FUNC(getSetting)],
    ["resumable", _mine],
    ["joinable", _open]
];

["ae3_games_view", [[_payload] call CBA_fnc_encodeJSON], _owner] call CBA_fnc_ownerEvent;
