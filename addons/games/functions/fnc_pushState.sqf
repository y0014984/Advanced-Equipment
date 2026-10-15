// File: fnc_pushState.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sends every seated device the view of the seat it is playing, and nothing else. The
 * rules function strips the rest, so a hand of cards or a ship layout never crosses the network to
 * an opponent. One message per seated device per move and nothing in between, and a device nobody is
 * using is skipped entirely rather than queued; a device holding more than one seat is told once,
 * for the seat it currently has in front of it. Server only.
 *
 * Arguments:
 * 0: _tableId <STRING> - Table id
 *
 * Return Value:
 * None
 *
 * Example:
 * [_tableId] call AE3_games_fnc_pushState;
 *
 * Public: No
 */

params [["_tableId", "", [""]]];

if (!isServer) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {};

private _gameId = _table getOrDefault ["gameId", ""];
private _info = [_gameId] call FUNC(gameInfo);

if (_info isEqualTo []) exitWith {};

_info params ["_rules", "_minSeats", "_maxSeats", "_title", "_sideChoice"];

private _state = _table getOrDefault ["state", []];
private _seats = _table getOrDefault ["seats", []];
private _prefs = _table getOrDefault ["prefs", createHashMap];

// Seat list everyone may see: who is sitting where, never what they hold. A practice seat carries
// the name it was given so it is not mistaken for a second laptop on the network.
private _seatList = _seats apply
{
    _x params ["_seatDeviceNetId", "_seatIndex", ["_seatLabel", ""]];

    private _label = _seatLabel;

    if (_label isEqualTo "") then {_label = [objectFromNetId _seatDeviceNetId] call FUNC(deviceLabel)};

    [_seatIndex, _label, _prefs getOrDefault [str _seatIndex, "random"]]
};

// One message per device rather than per seat, because the seats a host gave itself for practice
// are all in front of the same player
private _devices = [];

{
    _devices pushBackUnique (_x select 0);
} forEach _seats;

{
    private _deviceNetId = _x;
    private _device = objectFromNetId _deviceNetId;

    if (!isNull _device) then
    {
        // Zero means nobody is sitting at that device, so there is no one to tell
        private _owner = [_device] call FUNC(operatorOwner);

        if (_owner > 0) then
        {
            private _seat = [_table, _deviceNetId] call FUNC(seatOf);

            private _payload = createHashMapFromArray
            [
                ["kind", "table"],
                ["device", _deviceNetId],
                ["id", _tableId],
                ["gameId", _gameId],
                ["title", _title],
                ["name", _table getOrDefault ["name", ""]],
                ["phase", _table getOrDefault ["phase", "lobby"]],
                ["turn", _table getOrDefault ["turn", 0]],
                ["winner", _table getOrDefault ["winner", -1]],
                ["seat", _seat],
                ["held", [_table, _deviceNetId] call FUNC(seatsOf)],
                ["isHost", (_table getOrDefault ["host", ""]) isEqualTo _deviceNetId],
                ["minSeats", _minSeats],
                ["seatCount", _maxSeats],
                ["seats", _seatList],
                ["sideChoice", _sideChoice],
                ["starter", _table getOrDefault ["starter", -1]],
                // What the front end is allowed to draw and offer on this device, rather than what
                // it feels like doing: both follow the mission's settings
                ["graphical", [_device, "GraphicalUI"] call FUNC(getSetting)],
                ["debugSeats", [_device, "DebugSeats"] call FUNC(getSetting)],
                ["status", _table getOrDefault ["status", ""]],
                ["view", ["view", _state, _seat] call _rules]
            ];

            ["ae3_games_view", [[_payload] call CBA_fnc_encodeJSON], _owner] call CBA_fnc_ownerEvent;
        };
    };
} forEach _devices;
