// File: fnc_rules_snakesladders.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Snakes and ladders for up to four seats. The die is rolled here, on the server, which
 * is the whole point of keeping the rules server side for a game of chance - a client cannot reroll
 * or choose its number. Type roll to take your turn. A six rolls again, a ladder carries a token up,
 * a snake takes it back down, and a roll that would pass one hundred does not move. First token to
 * land on one hundred exactly wins.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "roll"] call AE3_games_fnc_rules_snakesladders) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_positions one per seat, _side to move, _lastRoll, _lastKey, _result]

private _jumps = createHashMapFromArray
[
    // Ladders
    [1, 38], [4, 14], [9, 31], [21, 42], [28, 84], [36, 44], [51, 67], [71, 91], [80, 100],
    // Snakes
    [16, 6], [47, 26], [49, 11], [56, 53], [62, 19], [64, 60], [87, 24], [93, 73], [95, 75], [98, 78]
];

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _seatCount = _this param [1, 4];

        private _positions = [];

        for "_i" from 1 to _seatCount do {_positions pushBack 0};

        [_positions, 0, 0, "", -1]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_positions", []], ["_side", 0], ["_lastRoll", 0], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        _side
    };

    case "winner": {(_this param [1, []]) param [4, -1]};

    case "view":
    {
        // Nothing is hidden: every square is public. The board the players are on goes out with the
        // view as well, so the ladders and snakes that are drawn are the ones the rules use.
        (_this param [1, []]) params [["_positions", []], ["_side", 0], ["_lastRoll", 0], ["_lastKey", ""]];

        private _board = [];

        {
            _board pushBack [_x, _y];
        } forEach _jumps;

        [_positions, _side, _lastRoll, _lastKey, _board]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_positions", []], ["_side", 0], ["_lastRoll", 0], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, [_positions, _side, _lastRoll, _lastKey, _result]]};

        // A player who does not roll in time simply passes
        [true, [_positions, (_side + 1) mod (count _positions), 0, "$STR_AE3_Games_Status_TurnTimedOut", -1]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_positions", []], ["_side", 0], ["_lastRoll", 0], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};
        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _word = toLowerANSI (_move splitString " " joinString "");

        if !(_word in ["roll", "r"]) exitWith {[false, _state, "$STR_AE3_Games_Status_RollToPlay"]};

        private _roll = 1 + floor (random 6);
        private _newPositions = +_positions;
        private _position = _newPositions select _seat;
        private _target = _position + _roll;
        private _key = "$STR_AE3_Games_Status_Rolled";

        // A roll that would pass the last square does not move the token
        if (_target <= 100) then
        {
            private _jump = _jumps get _target;

            if (!isNil "_jump") then
            {
                _key = ["$STR_AE3_Games_Status_Snake", "$STR_AE3_Games_Status_Ladder"] select (_jump > _target);
                _target = _jump;
            };

            _newPositions set [_seat, _target];
        }
        else
        {
            _key = "$STR_AE3_Games_Status_RollTooHigh";
        };

        private _newResult = -1;

        if ((_newPositions select _seat) isEqualTo 100) then
        {
            _newResult = _seat;
            _key = "$STR_AE3_Games_Status_Home";
        };

        // A six rolls again
        private _nextSide = _side;

        if (_roll isNotEqualTo 6) then
        {
            _nextSide = (_side + 1) mod (count _newPositions);
        };

        [true, [_newPositions, _nextSide, _roll, _key, _newResult], _key]
    };

    default {[]};
};
