// File: fnc_rules_chess.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Chess rules. Runs only on the server, only when a move arrives, and holds the whole
 * truth about a match so a client cannot move an opponent's piece, move out of turn or move illegally.
 * Seat 0 plays white, seat 1 plays black. Moves are written from square to square, e2e4, and a pawn
 * reaching the last rank becomes a queen. Castling is supported through the usual king move, e1g1;
 * en passant is not. Check, checkmate and stalemate are detected, and a side with no legal move is
 * either mated or in a draw. Every game's rules function answers the same small set of requests, so
 * the framework never special cases a game.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, see below
 *
 * "new"     [_seatCount] -> _state
 * "turn"    [_state] -> seat to move, or -1 when any seat may move
 * "apply"   [_state, _seat, _move] -> [_ok, _newState, _reasonKey]
 * "view"    [_state, _seat] -> what that seat is allowed to see
 * "winner"  [_state] -> -1 still running, seat index, or -2 for a draw
 * "timeout" [_state] -> [_ok, _newState], the side to move forfeits
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "e2e4"] call AE3_games_fnc_rules_chess) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_board 64 chars, _side to move 0 white 1 black, _castling rights, _result]
// Board index 0 is a8 and index 63 is h1, the order a FEN is written in.

private _fnc_squareToIndex =
{
    params ["_square"];

    if (count _square < 2) exitWith {-1};

    private _file = ["a", "b", "c", "d", "e", "f", "g", "h"] find (toLowerANSI (_square select [0, 1]));
    private _rank = parseNumber (_square select [1, 1]);

    if (_file < 0 || (_rank < 1) || (_rank > 8)) exitWith {-1};

    (8 - _rank) * 8 + _file
};

private _fnc_isWhite = {(_this isNotEqualTo ".") && {_this isEqualTo (toUpperANSI _this)}};
private _fnc_isBlack = {(_this isNotEqualTo ".") && {_this isEqualTo (toLowerANSI _this)}};

private _fnc_ownedBy =
{
    params ["_piece", "_side"];

    if (_piece isEqualTo ".") exitWith {false};

    if (_side isEqualTo 0) exitWith {_piece call _fnc_isWhite};

    _piece call _fnc_isBlack
};

// True when _side attacks square _target, ignoring whether that would expose its own king. Used both
// for check detection and for the squares a castling king may not cross.
private _fnc_attacked =
{
    params ["_board", "_target", "_side"];

    private _targetFile = _target mod 8;
    private _targetRank = floor (_target / 8);
    private _hit = false;

    {
        private _piece = _x;

        if (!_hit && {[_piece, _side] call _fnc_ownedBy}) then
        {
            private _from = _forEachIndex;
            private _file = _from mod 8;
            private _rank = floor (_from / 8);
            private _dFile = _targetFile - _file;
            private _dRank = _targetRank - _rank;
            private _absFile = abs _dFile;
            private _absRank = abs _dRank;
            private _type = toLowerANSI _piece;

            private _clear =
            {
                private _stepFile = 0;
                private _stepRank = 0;

                if (_dFile > 0) then {_stepFile = 1};
                if (_dFile < 0) then {_stepFile = -1};
                if (_dRank > 0) then {_stepRank = 1};
                if (_dRank < 0) then {_stepRank = -1};

                private _steps = _absFile max _absRank;
                private _blocked = false;

                for "_i" from 1 to (_steps - 1) do
                {
                    private _index = (_rank + _stepRank * _i) * 8 + (_file + _stepFile * _i);

                    if ((_board select _index) isNotEqualTo ".") then {_blocked = true};
                };

                !_blocked
            };

            switch (_type) do
            {
                case "p":
                {
                    // White pawns attack towards rank 8, which is a lower board index
                    private _forward = [-1, 1] select _side;

                    if (_absFile isEqualTo 1 && (_dRank isEqualTo _forward)) then {_hit = true};
                };
                case "n":
                {
                    if ((_absFile isEqualTo 1 && (_absRank isEqualTo 2)) || {_absFile isEqualTo 2 && (_absRank isEqualTo 1)}) then {_hit = true};
                };
                case "b":
                {
                    if (_absFile isEqualTo _absRank && (_absFile > 0) && {call _clear}) then {_hit = true};
                };
                case "r":
                {
                    if ((_absFile isEqualTo 0 || (_absRank isEqualTo 0)) && {(_absFile + _absRank) > 0} && {call _clear}) then {_hit = true};
                };
                case "q":
                {
                    if (((_absFile isEqualTo _absRank) || (_absFile isEqualTo 0) || (_absRank isEqualTo 0)) && {(_absFile + _absRank) > 0} && {call _clear}) then {_hit = true};
                };
                case "k":
                {
                    if (_absFile <= 1 && (_absRank <= 1) && {(_absFile + _absRank) > 0}) then {_hit = true};
                };
                default {};
            };
        };
    } forEach _board;

    _hit
};

private _fnc_kingIndex =
{
    params ["_board", "_side"];

    private _king = ["K", "k"] select _side;

    _board find _king
};

// Pseudo-legal check for one move: the piece's own movement rules, blocking and capture ownership,
// plus castling. King safety is tested afterwards by actually making the move.
private _fnc_canMove =
{
    params ["_board", "_from", "_to", "_side", "_castling"];

    if (_from isEqualTo _to) exitWith {false};

    private _piece = _board select _from;
    private _target = _board select _to;

    if (!([_piece, _side] call _fnc_ownedBy)) exitWith {false};
    if ([_target, _side] call _fnc_ownedBy) exitWith {false};

    private _file = _from mod 8;
    private _rank = floor (_from / 8);
    private _toFile = _to mod 8;
    private _toRank = floor (_to / 8);
    private _dFile = _toFile - _file;
    private _dRank = _toRank - _rank;
    private _absFile = abs _dFile;
    private _absRank = abs _dRank;
    private _type = toLowerANSI _piece;

    private _clearPath =
    {
        private _stepFile = 0;
        private _stepRank = 0;

        if (_dFile > 0) then {_stepFile = 1};
        if (_dFile < 0) then {_stepFile = -1};
        if (_dRank > 0) then {_stepRank = 1};
        if (_dRank < 0) then {_stepRank = -1};

        private _steps = _absFile max _absRank;
        private _blocked = false;

        for "_i" from 1 to (_steps - 1) do
        {
            private _index = (_rank + _stepRank * _i) * 8 + (_file + _stepFile * _i);

            if ((_board select _index) isNotEqualTo ".") then {_blocked = true};
        };

        !_blocked
    };

    switch (_type) do
    {
        case "p":
        {
            private _forward = [-1, 1] select _side;
            private _startRank = [6, 1] select _side;

            // Capture
            if (_absFile isEqualTo 1 && (_dRank isEqualTo _forward)) exitWith {_target isNotEqualTo "."};

            if (_dFile isNotEqualTo 0) exitWith {false};

            // Single step
            if (_dRank isEqualTo _forward) exitWith {_target isEqualTo "."};

            // Opening double step
            if (_dRank isEqualTo (_forward * 2) && (_rank isEqualTo _startRank)) exitWith
            {
                private _between = (_rank + _forward) * 8 + _file;

                (_target isEqualTo ".") && {(_board select _between) isEqualTo "."}
            };

            false
        };
        case "n": {(_absFile isEqualTo 1 && (_absRank isEqualTo 2)) || {_absFile isEqualTo 2 && (_absRank isEqualTo 1)}};
        case "b": {_absFile isEqualTo _absRank && {call _clearPath}};
        case "r": {(_absFile isEqualTo 0 || (_absRank isEqualTo 0)) && {call _clearPath}};
        case "q": {((_absFile isEqualTo _absRank) || (_absFile isEqualTo 0) || (_absRank isEqualTo 0)) && {call _clearPath}};
        case "k":
        {
            if (_absFile <= 1 && (_absRank <= 1)) exitWith {true};

            // Castling: the king's two square move, with rights, an empty path and no square it
            // starts on, crosses or lands on under attack
            if (_absRank isNotEqualTo 0 || (_absFile isNotEqualTo 2)) exitWith {false};

            private _homeRank = [7, 0] select _side;

            if (_rank isNotEqualTo _homeRank || (_file isNotEqualTo 4)) exitWith {false};

            private _short = _dFile > 0;
            private _rightIndex = ([0, 2] select _side) + (parseNumber !_short);
            private _right = ["K", "Q", "k", "q"] select _rightIndex;

            if !(_right in (_castling splitString "")) exitWith {false};

            private _rookFile = [0, 7] select _short;
            private _rookIndex = _homeRank * 8 + _rookFile;
            private _rook = ["R", "r"] select _side;

            if ((_board select _rookIndex) isNotEqualTo _rook) exitWith {false};

            private _files = [[1, 2, 3], [5, 6]] select _short;
            private _blocked = false;

            {
                if ((_board select (_homeRank * 8 + _x)) isNotEqualTo ".") then {_blocked = true};
            } forEach _files;

            if (_blocked) exitWith {false};

            private _enemy = [1, 0] select _side;
            private _crossing = [[4, 3, 2], [4, 5, 6]] select _short;
            private _throughCheck = false;

            {
                if ([_board, _homeRank * 8 + _x, _enemy] call _fnc_attacked) then {_throughCheck = true};
            } forEach _crossing;

            !_throughCheck
        };
        default {false};
    };
};

// Makes a move on a copy of the board, including the rook's half of a castle and promotion
private _fnc_makeMove =
{
    params ["_board", "_from", "_to", "_side"];

    private _new = +_board;
    private _piece = _new select _from;

    _new set [_from, "."];
    _new set [_to, _piece];

    private _type = toLowerANSI _piece;

    if (_type isEqualTo "k" && {(abs ((_to mod 8) - (_from mod 8))) isEqualTo 2}) then
    {
        private _homeRank = floor (_from / 8);
        private _short = (_to mod 8) > (_from mod 8);
        private _rookFrom = _homeRank * 8 + ([0, 7] select _short);
        private _rookTo = _homeRank * 8 + ([3, 5] select _short);

        _new set [_rookTo, _new select _rookFrom];
        _new set [_rookFrom, "."];
    };

    if (_type isEqualTo "p") then
    {
        private _lastRank = [0, 7] select _side;

        if ((floor (_to / 8)) isEqualTo _lastRank) then
        {
            _new set [_to, ["Q", "q"] select _side];
        };
    };

    _new
};

// Castling rights are lost by moving a king or a rook, or by having a rook captured on its home square
private _fnc_updateCastling =
{
    params ["_castling", "_board", "_from", "_to"];

    private _rights = _castling splitString "";
    private _piece = _board select _from;
    private _type = toLowerANSI _piece;

    if (_type isEqualTo "k") then
    {
        if (_piece isEqualTo "K") then {_rights = _rights - ["K", "Q"]};
        if (_piece isEqualTo "k") then {_rights = _rights - ["k", "q"]};
    };

    {
        _x params ["_square", "_right"];

        if (_from isEqualTo _square || (_to isEqualTo _square)) then {_rights = _rights - [_right]};
    } forEach [[56, "Q"], [63, "K"], [0, "q"], [7, "k"]];

    _rights joinString ""
};

// Does this side have any legal move at all? Answers mate and stalemate in one go.
private _fnc_hasLegalMove =
{
    params ["_board", "_side", "_castling"];

    private _found = false;
    private _enemy = [1, 0] select _side;

    {
        private _piece = _x;

        if (!_found && {[_piece, _side] call _fnc_ownedBy}) then
        {
            private _from = _forEachIndex;

            for "_to" from 0 to 63 do
            {
                if (!_found && {[_board, _from, _to, _side, _castling] call _fnc_canMove}) then
                {
                    private _after = [_board, _from, _to, _side] call _fnc_makeMove;

                    if (!([_after, [_after, _side] call _fnc_kingIndex, _enemy] call _fnc_attacked)) then {_found = true};
                };
            };
        };
    } forEach _board;

    _found
};

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _board = "rnbqkbnr" + "pppppppp" + "........" + "........" + "........" + "........" + "PPPPPPPP" + "RNBQKBNR";

        [_board, 0, "KQkq", -1]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_board", ""], ["_side", 0], ["_castling", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        _side
    };

    case "winner":
    {
        (_this param [1, []]) param [3, -1]
    };

    case "view":
    {
        // Chess hides nothing, so both seats see the same board. Games with hidden information strip
        // it here instead.
        (_this param [1, []]) params [["_board", ""], ["_side", 0], ["_castling", ""], ["_result", -1]];

        private _cells = _board splitString "";
        private _check = false;

        if (_result isEqualTo -1) then
        {
            private _enemy = [1, 0] select _side;

            _check = [_cells, [_cells, _side] call _fnc_kingIndex, _enemy] call _fnc_attacked;
        };

        [_board, _side, _check]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_board", ""], ["_side", 0], ["_castling", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, [_board, _side, _castling, _result]]};

        // The side that ran out of time loses
        [true, [_board, _side, _castling, ([1, 0] select _side)]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_board", ""], ["_side", 0], ["_castling", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};
        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _text = toLowerANSI (_move splitString " " joinString "");

        if (count _text < 4) exitWith {[false, _state, "$STR_AE3_Games_Status_BadNotation"]};

        private _from = [_text select [0, 2]] call _fnc_squareToIndex;
        private _to = [_text select [2, 2]] call _fnc_squareToIndex;

        if (_from < 0 || (_to < 0)) exitWith {[false, _state, "$STR_AE3_Games_Status_BadNotation"]};

        private _cells = _board splitString "";

        if (!([_cells, _from, _to, _side, _castling] call _fnc_canMove)) exitWith {[false, _state, "$STR_AE3_Games_Status_IllegalMove"]};

        private _after = [_cells, _from, _to, _side] call _fnc_makeMove;
        private _enemy = [1, 0] select _side;

        // A move that leaves or places your own king in check is not a move
        if ([_after, [_after, _side] call _fnc_kingIndex, _enemy] call _fnc_attacked) exitWith
        {
            [false, _state, "$STR_AE3_Games_Status_KingInCheck"]
        };

        private _newCastling = [_castling, _cells, _from, _to] call _fnc_updateCastling;
        private _nextSide = _enemy;
        private _newResult = -1;
        private _reason = "$STR_AE3_Games_Status_MoveMade";

        if (!([_after, _nextSide, _newCastling] call _fnc_hasLegalMove)) then
        {
            private _nextEnemy = [1, 0] select _nextSide;

            if ([_after, [_after, _nextSide] call _fnc_kingIndex, _nextEnemy] call _fnc_attacked) then
            {
                _newResult = _side;
                _reason = "$STR_AE3_Games_Status_Checkmate";
            }
            else
            {
                _newResult = -2;
                _reason = "$STR_AE3_Games_Status_Stalemate";
            };
        };

        [true, [_after joinString "", _nextSide, _newCastling, _newResult], _reason]
    };

    default {[]};
};
