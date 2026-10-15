// File: fnc_rules_checkers.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Checkers rules, on the same contract every AE3 game answers. Runs only on the server,
 * so a client cannot move an opponent's piece or skip a capture. Seat 0 plays the lower case w pieces
 * and moves up the board, seat 1 plays b and moves down. Moves are written from square to square,
 * c3d4; a capture is the two square jump, c3e5, and a piece that can carry on capturing keeps the
 * turn until it cannot. A piece reaching the far row becomes a king, written in capitals, which may
 * move and capture in every diagonal direction. A side with no pieces or no legal move has lost.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "c3d4"] call AE3_games_fnc_rules_checkers) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_board 64 chars, _side to move, _chain index of a piece mid capture or -1, _result]

private _fnc_squareToIndex =
{
    params ["_square"];

    if (count _square < 2) exitWith {-1};

    private _file = ["a", "b", "c", "d", "e", "f", "g", "h"] find (toLowerANSI (_square select [0, 1]));
    private _rank = parseNumber (_square select [1, 1]);

    if (_file < 0 || _rank < 1 || _rank > 8) exitWith {-1};

    (8 - _rank) * 8 + _file
};

private _fnc_ownedBy =
{
    params ["_piece", "_side"];

    if (_piece isEqualTo ".") exitWith {false};

    private _mine = ["w", "b"] select _side;

    (toLowerANSI _piece) isEqualTo _mine
};

// All moves a single piece has: [_to, _capturedIndex] with -1 when nothing is taken
private _fnc_pieceMoves =
{
    params ["_board", "_from", "_side", "_capturesOnly"];

    private _piece = _board select _from;

    if !([_piece, _side] call _fnc_ownedBy) exitWith {[]};

    private _file = _from mod 8;
    private _row = floor (_from / 8);
    private _isKing = _piece isEqualTo (toUpperANSI _piece);

    // Seat 0 moves towards row 0, seat 1 towards row 7
    private _forward = [-1, 1] select _side;
    private _directions = [[-1, _forward], [1, _forward]];

    if (_isKing) then {_directions = [[-1, -1], [1, -1], [-1, 1], [1, 1]]};

    private _moves = [];

    {
        _x params ["_stepFile", "_stepRow"];

        private _overFile = _file + _stepFile;
        private _overRow = _row + _stepRow;
        private _landFile = _file + 2 * _stepFile;
        private _landRow = _row + 2 * _stepRow;

        if (_overFile >= 0 && _overFile <= 7 && _overRow >= 0 && _overRow <= 7) then
        {
            private _overIndex = _overRow * 8 + _overFile;
            private _over = _board select _overIndex;

            // Plain step
            if (!_capturesOnly && (_over isEqualTo ".")) then
            {
                _moves pushBack [_overIndex, -1];
            };

            // Jump over an enemy piece onto an empty square
            if (_landFile >= 0 && _landFile <= 7 && _landRow >= 0 && _landRow <= 7) then
            {
                private _landIndex = _landRow * 8 + _landFile;

                if ((_over isNotEqualTo ".") && !([_over, _side] call _fnc_ownedBy) && ((_board select _landIndex) isEqualTo ".")) then
                {
                    _moves pushBack [_landIndex, _overIndex];
                };
            };
        };
    } forEach _directions;

    _moves
};

private _fnc_sideMoves =
{
    params ["_board", "_side", "_capturesOnly"];

    private _all = [];

    {
        if ([_x, _side] call _fnc_ownedBy) then
        {
            private _from = _forEachIndex;

            {
                _all pushBack [_from, _x select 0, _x select 1];
            } forEach ([_board, _from, _side, _capturesOnly] call _fnc_pieceMoves);
        };
    } forEach _board;

    _all
};

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _cells = [];

        for "_index" from 0 to 63 do
        {
            private _row = floor (_index / 8);
            private _dark = ((_row + (_index mod 8)) mod 2) isEqualTo 1;
            private _cell = ".";

            if (_dark && _row <= 2) then {_cell = "b"};
            if (_dark && _row >= 5) then {_cell = "w"};

            _cells pushBack _cell;
        };

        [_cells joinString "", 0, -1, -1]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_board", ""], ["_side", 0], ["_chain", -1], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        _side
    };

    case "winner": {(_this param [1, []]) param [3, -1]};

    case "view":
    {
        // Checkers hides nothing: both seats see the same board
        (_this param [1, []]) params [["_board", ""], ["_side", 0], ["_chain", -1]];

        [_board, _side, _chain]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_board", ""], ["_side", 0], ["_chain", -1], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, [_board, _side, _chain, _result]]};

        [true, [_board, _side, _chain, 1 - _side]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_board", ""], ["_side", 0], ["_chain", -1], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};
        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _text = toLowerANSI (_move splitString " " joinString "");

        if (count _text < 4) exitWith {[false, _state, "$STR_AE3_Games_Status_BadNotation"]};

        private _from = [_text select [0, 2]] call _fnc_squareToIndex;
        private _to = [_text select [2, 2]] call _fnc_squareToIndex;

        if (_from < 0 || _to < 0) exitWith {[false, _state, "$STR_AE3_Games_Status_BadNotation"]};

        // A piece in the middle of a capture run has to carry on with that same piece
        if (_chain >= 0 && (_from isNotEqualTo _chain)) exitWith {[false, _state, "$STR_AE3_Games_Status_MustContinueCapture"]};

        private _cells = _board splitString "";

        // A capture on offer anywhere has to be taken
        private _captures = [_cells, _side, true] call _fnc_sideMoves;
        private _options = [_cells, _from, _side, _captures isNotEqualTo []] call _fnc_pieceMoves;
        private _index = _options findIf {(_x select 0) isEqualTo _to};

        if (_index < 0) exitWith
        {
            if (_captures isNotEqualTo []) exitWith {[false, _state, "$STR_AE3_Games_Status_MustCapture"]};

            [false, _state, "$STR_AE3_Games_Status_IllegalMove"]
        };

        (_options select _index) params ["", "_captured"];

        private _piece = _cells select _from;

        _cells set [_from, "."];
        _cells set [_to, _piece];

        if (_captured >= 0) then {_cells set [_captured, "."]};

        // A piece reaching the far row is crowned, and crowning ends the turn
        private _lastRow = [0, 7] select _side;
        private _crowned = false;

        if ((floor (_to / 8)) isEqualTo _lastRow && (_piece isEqualTo (toLowerANSI _piece))) then
        {
            _cells set [_to, toUpperANSI _piece];
            _crowned = true;
        };

        private _newChain = -1;
        private _nextSide = 1 - _side;
        private _reason = "$STR_AE3_Games_Status_MoveMade";

        // Carry on capturing with the same piece when it can
        if (_captured >= 0 && !_crowned && (([_cells, _to, _side, true] call _fnc_pieceMoves) isNotEqualTo [])) then
        {
            _newChain = _to;
            _nextSide = _side;
            _reason = "$STR_AE3_Games_Status_CaptureAgain";
        };

        private _newResult = -1;

        if (_nextSide isNotEqualTo _side) then
        {
            private _left = {[_x, _nextSide] call _fnc_ownedBy} count _cells;

            if (_left isEqualTo 0 || (([_cells, _nextSide, false] call _fnc_sideMoves) isEqualTo [])) then
            {
                _newResult = _side;
                _reason = "$STR_AE3_Games_Status_NoMovesLeft";
            };
        };

        [true, [_cells joinString "", _nextSide, _newChain, _newResult], _reason]
    };

    default {[]};
};
