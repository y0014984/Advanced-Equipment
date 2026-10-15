// File: fnc_rules_ludo.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Ludo for up to four seats, four tokens each. The die is rolled on the server, so a
 * client cannot pick its number. A turn is two steps: type roll, then the number of the token to
 * move. A six brings a token out of the yard, and a six, a capture or getting a token home all roll
 * again. Landing on a square held by a single opposing token sends that token back to its yard.
 * Reaching home needs the exact number. First seat with all four tokens home wins. Each token's
 * position is counted from its own seat's starting square: 0 is the yard, 1 to 51 is the shared
 * track, 52 to 56 is that seat's home column and 57 is home.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "roll"] call AE3_games_fnc_rules_ludo) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_tokens one array of four positions per seat, _side, _pendingRoll, _lastKey, _result]

// Where a seat-relative track position sits on the shared ring, so captures can be worked out
private _fnc_absolute =
{
    params ["_seat", "_position"];

    if (_position < 1 || _position > 51) exitWith {-1};

    ((_seat * 13) + _position - 1) mod 52
};

private _fnc_legalTokens =
{
    params ["_tokens", "_seat", "_roll"];

    private _mine = _tokens select _seat;
    private _legal = [];

    {
        private _position = _x;
        private _token = _forEachIndex;

        if (_position isEqualTo 0) then
        {
            // Only a six brings a token out of the yard
            if (_roll isEqualTo 6) then {_legal pushBack _token};
        }
        else
        {
            if (_position < 57 && ((_position + _roll) <= 57)) then {_legal pushBack _token};
        };
    } forEach _mine;

    _legal
};

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _seatCount = _this param [1, 4];
        private _tokens = [];

        for "_i" from 1 to _seatCount do {_tokens pushBack [0, 0, 0, 0]};

        [_tokens, 0, 0, "", -1]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_tokens", []], ["_side", 0], ["_pendingRoll", 0], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        _side
    };

    case "winner": {(_this param [1, []]) param [4, -1]};

    case "view":
    {
        // Every token's position is public in ludo
        (_this param [1, []]) params [["_tokens", []], ["_side", 0], ["_pendingRoll", 0], ["_lastKey", ""]];

        [_tokens, _side, _pendingRoll, _lastKey]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_tokens", []], ["_side", 0], ["_pendingRoll", 0], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, [_tokens, _side, _pendingRoll, _lastKey, _result]]};

        [true, [_tokens, (_side + 1) mod (count _tokens), 0, "$STR_AE3_Games_Status_TurnTimedOut", -1]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_tokens", []], ["_side", 0], ["_pendingRoll", 0], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};
        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _word = toLowerANSI (_move splitString " " joinString "");
        private _seatCount = count _tokens;

        // Step one: roll
        if (_word in ["roll", "r"]) exitWith
        {
            if (_pendingRoll > 0) exitWith {[false, _state, "$STR_AE3_Games_Status_AlreadyRolled"]};

            private _roll = 1 + floor (random 6);
            private _legal = [_tokens, _seat, _roll] call _fnc_legalTokens;

            // Nothing this roll can move, so the turn passes
            if (_legal isEqualTo []) exitWith
            {
                private _nextSide = [(_seat + 1) mod _seatCount, _seat] select (_roll isEqualTo 6);

                [true, [_tokens, _nextSide, 0, "$STR_AE3_Games_Status_NoTokenToMove", -1], "$STR_AE3_Games_Status_NoTokenToMove"]
            };

            [true, [_tokens, _seat, _roll, "$STR_AE3_Games_Status_Rolled", -1], "$STR_AE3_Games_Status_Rolled"]
        };

        // Step two: move a token
        if (_pendingRoll isEqualTo 0) exitWith {[false, _state, "$STR_AE3_Games_Status_RollFirst"]};

        private _token = (parseNumber _word) - 1;
        private _legal = [_tokens, _seat, _pendingRoll] call _fnc_legalTokens;

        if !(_token in _legal) exitWith {[false, _state, "$STR_AE3_Games_Status_NoSuchToken"]};

        private _newTokens = [];

        {
            _newTokens pushBack +_x;
        } forEach _tokens;

        private _mine = _newTokens select _seat;
        private _position = _mine select _token;
        private _target = [_position + _pendingRoll, 1] select (_position isEqualTo 0);

        _mine set [_token, _target];

        private _key = "$STR_AE3_Games_Status_TokenMoved";
        private _captured = false;

        // A single opposing token on the same shared square is sent back to its yard
        private _absolute = [_seat, _target] call _fnc_absolute;

        if (_absolute >= 0) then
        {
            for "_other" from 0 to (_seatCount - 1) do
            {
                if (_other isNotEqualTo _seat) then
                {
                    private _theirs = _newTokens select _other;
                    private _onSquare = [];

                    {
                        if (([_other, _x] call _fnc_absolute) isEqualTo _absolute) then {_onSquare pushBack _forEachIndex};
                    } forEach _theirs;

                    if (count _onSquare isEqualTo 1) then
                    {
                        _theirs set [_onSquare select 0, 0];
                        _captured = true;
                    };
                };
            };
        };

        if (_captured) then {_key = "$STR_AE3_Games_Status_TokenCaptured"};

        private _home = _target isEqualTo 57;

        if (_home) then {_key = "$STR_AE3_Games_Status_TokenHome"};

        private _newResult = -1;

        if (({_x isEqualTo 57} count _mine) isEqualTo (count _mine)) then
        {
            _newResult = _seat;
            _key = "$STR_AE3_Games_Status_AllHome";
        };

        // A six, a capture or a token reaching home all earn another turn
        private _again = (_pendingRoll isEqualTo 6) || _captured || _home;
        private _nextSide = [(_seat + 1) mod _seatCount, _seat] select _again;

        [true, [_newTokens, _nextSide, 0, _key, _newResult], _key]
    };

    default {[]};
};
