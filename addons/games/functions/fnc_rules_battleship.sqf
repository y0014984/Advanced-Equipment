// File: fnc_rules_battleship.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Battleship for two seats on ten by ten grids. A match begins with both seats laying
 * out a fleet of five ships - five, four, three, three and two squares - either by placing each one
 * by square and heading or by asking for a random layout, and firing starts once both have said they
 * are ready. Neither fleet ever leaves the server: a seat is sent its own grid with the shots fired
 * at it, of the opponent grid only the hits and misses it has scored itself, and a count of how many
 * ships on each side are still afloat. That is the reason a game of hidden information has to be
 * decided server side - a client simply does not hold the answer. Fire by naming a square, b5 or e10.
 * A hit fires again, and sinking all five ships wins.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "b5"] call AE3_games_fnc_rules_battleship) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_fleets one list of [length, cell indices] per seat, _shots what each seat has fired at
//         the other, _side, _lastKey, _result, _ready one flag per seat]

private _lengths = [5, 4, 3, 3, 2];

private _fnc_squareToIndex =
{
    params ["_square"];

    private _text = toLowerANSI (_square splitString " " joinString "");

    if (count _text < 2) exitWith {-1};

    private _column = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"] find (_text select [0, 1]);
    private _row = parseNumber (_text select [1]);

    if (_column < 0 || _row < 1 || _row > 10) exitWith {-1};

    (_row - 1) * 10 + _column
};

// The grid a fleet makes, which is what both the board drawing and the firing work from
private _fnc_gridOf =
{
    params ["_fleet"];

    private _cells = [];

    for "_i" from 1 to 100 do {_cells pushBack "."};

    {
        {
            _cells set [_x, "S"];
        } forEach (_x param [1, []]);
    } forEach _fleet;

    _cells joinString ""
};

// The squares a ship of this length would take from a starting square, or [] when it would run off
// the edge of the grid
private _fnc_footprint =
{
    params ["_index", "_length", "_horizontal"];

    private _row = floor (_index / 10);
    private _column = _index mod 10;

    if (_horizontal && {_column + _length > 10}) exitWith {[]};
    if (!_horizontal && {_row + _length > 10}) exitWith {[]};

    private _indices = [];

    for "_step" from 0 to (_length - 1) do
    {
        _indices pushBack ((_row + ([0, _step] select !_horizontal)) * 10 + _column + ([0, _step] select _horizontal));
    };

    _indices
};

private _fnc_randomFleet =
{
    params ["_shipLengths"];

    private _fleet = [];
    private _used = [];

    {
        private _length = _x;
        private _indices = [];
        private _attempts = 0;

        while {_indices isEqualTo []} do
        {
            // The no touching rule is dropped after a few hundred tries rather than risking a loop
            // that never ends on the server
            _attempts = _attempts + 1;

            private _candidate = [floor (random 100), _length, (random 1) < 0.5] call _fnc_footprint;

            if (_candidate isNotEqualTo []) then
            {
                private _reach = parseNumber (_attempts < 400);
                private _clear = true;

                {
                    private _ir = floor (_x / 10);
                    private _ic = _x mod 10;

                    for "_dr" from -_reach to _reach do
                    {
                        for "_dc" from -_reach to _reach do
                        {
                            private _nr = _ir + _dr;
                            private _nc = _ic + _dc;

                            if (_nr >= 0 && _nr <= 9 && _nc >= 0 && _nc <= 9 && {((_nr * 10) + _nc) in _used}) then
                            {
                                _clear = false;
                            };
                        };
                    };
                } forEach _candidate;

                if (_clear) then
                {
                    _indices = _candidate;
                    _used append _candidate;
                };
            };
        };

        _fleet pushBack [_length, _indices];
    } forEach _shipLengths;

    _fleet
};

// How many ships of a fleet still have a square that has not been hit
private _fnc_afloat =
{
    params ["_fleet", "_incoming"];

    private _cells = _incoming splitString "";
    private _count = 0;

    {
        private _indices = _x param [1, []];

        if (_indices isNotEqualTo [] && {(_indices findIf {(_cells param [_x, "."]) isNotEqualTo "x"}) >= 0}) then
        {
            _count = _count + 1;
        };
    } forEach _fleet;

    _count
};

// True when every ship of a fleet has been given its squares
private _fnc_placed = {((_this param [0, []]) findIf {(_x param [1, []]) isEqualTo []}) isEqualTo -1};

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _empty = [];

        for "_i" from 1 to 100 do {_empty pushBack "."};

        private _blank = _empty joinString "";

        // Both fleets start laid out at random, so a seat that would rather not place anything can
        // simply say it is ready
        [[[_lengths] call _fnc_randomFleet, [_lengths] call _fnc_randomFleet], [_blank, _blank], 0, "", -1, [false, false]]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_fleets", []], ["_shots", []], ["_side", 0], ["_lastKey", ""], ["_result", -1], ["_ready", [false, false]]];

        if (_result isNotEqualTo -1) exitWith {-1};

        // While fleets are being laid out both seats work at once, as neither is waiting on the other
        if (_ready isNotEqualTo [true, true]) exitWith {-1};

        _side
    };

    case "winner": {(_this param [1, []]) param [4, -1]};

    case "view":
    {
        (_this param [1, []]) params [["_fleets", []], ["_shots", []], ["_side", 0], ["_lastKey", ""], ["_result", -1], ["_ready", [false, false]]];

        private _seat = _this param [2, 0];
        private _other = 1 - _seat;

        // Own waters: own ships with the hits and misses the opponent has scored marked on them
        private _ownFleet = _fleets param [_seat, []];
        private _ownCells = ([_ownFleet] call _fnc_gridOf) splitString "";
        private _incoming = _shots param [_other, ""];

        {
            if (_x in ["x", "o"]) then {_ownCells set [_forEachIndex, _x]};
        } forEach (_incoming splitString "");

        // Enemy waters: only what this seat has found out by firing. The opponent layout is not part
        // of the answer, so there is nothing for a client to read; how many of its ships are still
        // afloat is, because sinking one is announced at a real table too.
        [
            _ownCells joinString "",
            _shots param [_seat, ""],
            _side,
            _lastKey,
            ["setup", "play"] select (_ready isEqualTo [true, true]),
            _ownFleet,
            [_ownFleet, _incoming] call _fnc_afloat,
            [_fleets param [_other, []], _shots param [_seat, ""]] call _fnc_afloat,
            _ready
        ]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_fleets", []], ["_shots", []], ["_side", 0], ["_lastKey", ""], ["_result", -1], ["_ready", [false, false]]];

        if (_result isNotEqualTo -1) exitWith {[false, [_fleets, _shots, _side, _lastKey, _result, _ready]]};

        // A seat still laying out its fleet when the clock runs out keeps the layout it has
        if (_ready isNotEqualTo [true, true]) exitWith
        {
            [true, [_fleets, _shots, _side, "$STR_AE3_Games_Status_TurnTimedOut", -1, [true, true]]]
        };

        [true, [_fleets, _shots, 1 - _side, "$STR_AE3_Games_Status_TurnTimedOut", -1, _ready]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_fleets", []], ["_shots", []], ["_side", 0], ["_lastKey", ""], ["_result", -1], ["_ready", [false, false]]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};

        private _words = ((toLowerANSI _move) splitString " ") select {_x isNotEqualTo ""};
        private _command = _words param [0, ""];

        // Laying out the fleet: each seat works on its own grid until it says it is ready
        if (_ready isNotEqualTo [true, true]) exitWith
        {
            if (_ready param [_seat, false]) exitWith {[false, _state, "$STR_AE3_Games_Status_WaitingForFleet"]};

            private _newFleets = +_fleets;
            private _fleet = +(_newFleets param [_seat, []]);

            switch (_command) do
            {
                case "random";
                case "r":
                {
                    _newFleets set [_seat, [_lengths] call _fnc_randomFleet];

                    [true, [_newFleets, _shots, _side, "$STR_AE3_Games_Status_FleetPlaced", -1, _ready], "$STR_AE3_Games_Status_FleetPlaced"]
                };

                case "clear":
                {
                    _newFleets set [_seat, _lengths apply {[_x, []]}];

                    [true, [_newFleets, _shots, _side, "$STR_AE3_Games_Status_FleetCleared", -1, _ready], "$STR_AE3_Games_Status_FleetCleared"]
                };

                case "ready":
                {
                    if !([_fleet] call _fnc_placed) exitWith {[false, _state, "$STR_AE3_Games_Status_FleetIncomplete"]};

                    private _newReady = +_ready;
                    _newReady set [_seat, true];

                    private _key = ["$STR_AE3_Games_Status_FleetReady", "$STR_AE3_Games_Status_FireAway"] select (_newReady isEqualTo [true, true]);

                    [true, [_newFleets, _shots, _side, _key, -1, _newReady], _key]
                };

                case "place";
                case "p":
                {
                    private _ship = (round (parseNumber (_words param [1, "0"]))) - 1;
                    private _index = [_words param [2, ""]] call _fnc_squareToIndex;
                    private _horizontal = (_words param [3, "h"]) isNotEqualTo "v";

                    if (_ship < 0 || {_ship >= count _fleet}) exitWith {[false, _state, "$STR_AE3_Games_Status_NoSuchShip"]};
                    if (_index < 0) exitWith {[false, _state, "$STR_AE3_Games_Status_BadSquare"]};

                    private _indices = [_index, (_fleet param [_ship, [0, []]]) param [0, 0], _horizontal] call _fnc_footprint;

                    if (_indices isEqualTo []) exitWith {[false, _state, "$STR_AE3_Games_Status_ShipOffGrid"]};

                    // Every other ship of this fleet has to stay clear of the squares it would take
                    private _taken = [];

                    {
                        if (_forEachIndex isNotEqualTo _ship) then {_taken append (_x param [1, []])};
                    } forEach _fleet;

                    if ((_indices findIf {_x in _taken}) >= 0) exitWith {[false, _state, "$STR_AE3_Games_Status_ShipsOverlap"]};

                    _fleet set [_ship, [count _indices, _indices]];
                    _newFleets set [_seat, _fleet];

                    [true, [_newFleets, _shots, _side, "$STR_AE3_Games_Status_ShipPlaced", -1, _ready], "$STR_AE3_Games_Status_ShipPlaced"]
                };

                default {[false, _state, "$STR_AE3_Games_Status_PlaceYourFleet"]};
            }
        };

        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _index = [_move] call _fnc_squareToIndex;

        if (_index < 0) exitWith {[false, _state, "$STR_AE3_Games_Status_BadSquare"]};

        private _mine = (_shots param [_seat, ""]) splitString "";

        if ((_mine select _index) isNotEqualTo ".") exitWith {[false, _state, "$STR_AE3_Games_Status_AlreadyFired"]};

        private _other = 1 - _seat;
        private _targetFleet = _fleets param [_other, []];
        private _hit = ((([_targetFleet] call _fnc_gridOf) splitString "") select _index) isEqualTo "S";

        _mine set [_index, ["o", "x"] select _hit];

        private _newShots = +_shots;
        _newShots set [_seat, _mine joinString ""];

        private _key = ["$STR_AE3_Games_Status_Miss", "$STR_AE3_Games_Status_ShipHit"] select _hit;
        private _newResult = -1;

        // Not one ship of the other fleet left afloat means the fleet is gone
        if (([_targetFleet, _newShots param [_seat, ""]] call _fnc_afloat) isEqualTo 0) then
        {
            _newResult = _seat;
            _key = "$STR_AE3_Games_Status_FleetSunk";
        };

        // A hit fires again
        [true, [_fleets, _newShots, [_other, _seat] select _hit, _key, _newResult, _ready], _key]
    };

    default {[]};
};
