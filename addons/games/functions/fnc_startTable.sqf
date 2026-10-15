// File: fnc_startTable.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Starts a table that is waiting in its lobby, once it holds at least the minimum number
 * of seats the game needs. The board is built here rather than when the table was opened, because a
 * game for up to eight seats has to be dealt for the number of players who actually sat down. Only
 * the hosting device may start a table, and a table that is full starts by itself. Runs on the server;
 * a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the device asking
 * 1: _tableId <STRING> - Table id
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "uno-2"] call AE3_games_fnc_startTable;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]]];

if (!isServer) exitWith {["ae3_games_start", [_deviceNetId, _tableId]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, "$STR_AE3_Games_Status_NoSuchTable"] call FUNC(pushNotice)};

if ((_table getOrDefault ["phase", "lobby"]) isNotEqualTo "lobby") exitWith
{
    [_device, "$STR_AE3_Games_Status_AlreadyStarted"] call FUNC(pushNotice);
};

if ((_table getOrDefault ["host", ""]) isNotEqualTo _deviceNetId) exitWith
{
    [_device, "$STR_AE3_Games_Status_HostStartsIt"] call FUNC(pushNotice);
};

private _info = [_table getOrDefault ["gameId", ""]] call FUNC(gameInfo);

if (_info isEqualTo []) exitWith {};

_info params ["_rules", "_minSeats", "", "", "_sideChoice"];

private _seats = _table getOrDefault ["seats", []];

if (count _seats < _minSeats) exitWith {[_device, "$STR_AE3_Games_Status_NeedMorePlayers"] call FUNC(pushNotice)};

// Seat order is what decides who moves first and, in a game with two sides, which side each player
// gets, because every rules function builds its board for seat zero first. The lobby's answers are
// turned into that order here, once, and the seats are then renumbered to match.
private _ordered = +_seats;
private _refuse = false;

switch (_sideChoice) do
{
    case "colour":
    {
        private _prefs = _table getOrDefault ["prefs", createHashMap];
        private _slots = [];
        private _spare = [];
        private _clash = false;

        {
            _slots pushBack [];
        } forEach _seats;

        {
            private _wanted = ["white", "black"] find (_prefs getOrDefault [str (_x select 1), "random"]);

            if (_wanted >= 0 && {_wanted < count _slots}) then
            {
                // Two players asking for the same side is the one thing that keeps a table waiting
                if ((_slots select _wanted) isNotEqualTo []) then
                {
                    _clash = true;
                }
                else
                {
                    _slots set [_wanted, _x];
                };
            }
            else
            {
                _spare pushBack _x;
            };
        } forEach _seats;

        // Leaving the choice open is a refusal, not a seat order, so the answer is carried out of
        // the switch rather than returned from inside it
        if (_clash) exitWith {_refuse = true};

        // Whoever did not ask for a side is dealt one, so Random really is random
        private _shuffled = [];

        while {_spare isNotEqualTo []} do
        {
            _shuffled pushBack (_spare deleteAt (floor (random (count _spare))));
        };

        {
            if (_x isEqualTo []) then {_slots set [_forEachIndex, _shuffled deleteAt 0]};
        } forEach (+_slots);

        _ordered = _slots;
    };

    case "starter":
    {
        // The host named a seat to move first, so the table is turned until that seat is at the front
        private _at = _seats findIf {(_x select 1) isEqualTo (_table getOrDefault ["starter", -1])};

        if (_at > 0) then
        {
            _ordered = (_seats select [_at]) + (_seats select [0, _at]);
        };
    };

    default {};
};

if (_refuse) exitWith {[_device, "$STR_AE3_Games_Status_SideTaken"] call FUNC(pushNotice)};

// Seats are renumbered from zero so the games that pass a turn around the table can simply count
private _renumbered = [];

{
    _renumbered pushBack [_x select 0, _forEachIndex, _x param [2, ""]];
} forEach _ordered;

private _state = ["new", count _renumbered] call _rules;

_table set ["seats", _renumbered];
_table set ["active", createHashMap];
_table set ["state", _state];
_table set ["turn", ["turn", _state] call _rules];
_table set ["phase", "play"];
_table set ["winner", -1];
_table set ["status", "$STR_AE3_Games_Status_Started"];
_table set ["lastMoveAt", serverTime];

missionNamespace setVariable [QGVAR(tables), _tables];

[_tableId] call FUNC(pushState);
