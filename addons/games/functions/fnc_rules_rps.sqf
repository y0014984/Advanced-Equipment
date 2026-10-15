// File: fnc_rules_rps.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Rock paper scissors, first to three rounds. Both seats throw at the same time, so this
 * is the one game whose turn is open to either seat, and the reason the rules decide what a seat may
 * see: a throw sits on the server until both are in, and the opposing client is told only that its
 * opponent has thrown, never what. Runs on the server. Write rock, paper or scissors, or just r, p
 * or s.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "rock"] call AE3_games_fnc_rules_rps) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_throws one per seat with "" for not yet, _scores, _round, _lastKey, _result,
//         _lastThrows both throws of the round that just finished, _lastWinner]

private _fnc_normalize =
{
    params ["_text"];

    private _word = toLowerANSI (_text splitString " " joinString "");

    if (_word in ["r", "rock"]) exitWith {"rock"};
    if (_word in ["p", "paper"]) exitWith {"paper"};
    if (_word in ["s", "scissors"]) exitWith {"scissors"};

    ""
};

switch (toLowerANSI _request) do
{
    case "new":
    {
        [["", ""], [0, 0], 1, "", -1, ["", ""], -1]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_throws", ["", ""]], ["_scores", [0, 0]], ["_round", 1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        // Either seat may throw at any time
        -1
    };

    case "winner": {(_this param [1, []]) param [4, -1]};

    case "view":
    {
        (_this param [1, []]) params [["_throws", ["", ""]], ["_scores", [0, 0]], ["_round", 1], ["_lastKey", ""], ["_result", -1], ["_lastThrows", ["", ""]], ["_lastWinner", -1]];

        private _seat = _this param [2, 0];
        private _other = 1 - _seat;

        // The opponent throw is never sent while the round is open. Once the round is settled both
        // throws are, along with who took it, so the players can see what beat what.
        [_throws select _seat, (_throws select _other) isNotEqualTo "", _scores, _round, _lastKey, _lastThrows, _lastWinner]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_throws", ["", ""]], ["_scores", [0, 0]], ["_round", 1], ["_lastKey", ""], ["_result", -1], ["_lastThrows", ["", ""]], ["_lastWinner", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, [_throws, _scores, _round, _lastKey, _result, _lastThrows, _lastWinner]]};

        // Whoever has not thrown loses the match
        private _loser = _throws findIf {_x isEqualTo ""};

        if (_loser < 0) exitWith {[false, [_throws, _scores, _round, _lastKey, _result, _lastThrows, _lastWinner]]};

        [true, [_throws, _scores, _round, "$STR_AE3_Games_Status_TurnTimedOut", 1 - _loser, _lastThrows, _lastWinner]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_throws", ["", ""]], ["_scores", [0, 0]], ["_round", 1], ["_lastKey", ""], ["_result", -1], ["_lastThrows", ["", ""]], ["_lastWinner", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};

        private _throw = [_move] call _fnc_normalize;

        if (_throw isEqualTo "") exitWith {[false, _state, "$STR_AE3_Games_Status_BadThrow"]};
        if ((_throws select _seat) isNotEqualTo "") exitWith {[false, _state, "$STR_AE3_Games_Status_AlreadyThrown"]};

        private _newThrows = +_throws;
        _newThrows set [_seat, _throw];

        // Waiting for the other seat: nothing is revealed yet
        if ((_newThrows select (1 - _seat)) isEqualTo "") exitWith
        {
            [true, [_newThrows, _scores, _round, "$STR_AE3_Games_Status_ThrowMade", -1, _lastThrows, _lastWinner], "$STR_AE3_Games_Status_ThrowMade"]
        };

        private _beats = createHashMapFromArray [["rock", "scissors"], ["paper", "rock"], ["scissors", "paper"]];
        private _first = _newThrows select 0;
        private _second = _newThrows select 1;
        private _newScores = +_scores;
        private _key = "$STR_AE3_Games_Status_RoundDrawn";

        // -2 is a drawn round, a seat index is the seat that took it
        private _roundWinner = -2;

        if (_first isNotEqualTo _second) then
        {
            // Seat 0 wins the round when its throw beats the throw of seat 1
            private _winnerSeat = parseNumber ((_beats get _first) isNotEqualTo _second);

            _newScores set [_winnerSeat, (_newScores select _winnerSeat) + 1];
            _key = ["$STR_AE3_Games_Status_RoundToSeatOne", "$STR_AE3_Games_Status_RoundToSeatTwo"] select _winnerSeat;
            _roundWinner = _winnerSeat;
        };

        private _newResult = -1;

        {
            if (_x >= 3) then {_newResult = _forEachIndex};
        } forEach _newScores;

        // Both throws are carried forward so the finished round can be shown before the next one
        [true, [["", ""], _newScores, _round + 1, _key, _newResult, _newThrows, _roundWinner], _key]
    };

    default {[]};
};
