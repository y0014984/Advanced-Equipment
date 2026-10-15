// File: fnc_rules_uno.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Uno for up to eight seats. The shuffled deck and every hand live on the server, and a
 * seat is only ever told its own cards and how many the others hold, which is why the rules decide
 * what each seat may see. Cards are written as a colour letter and a value: R5, G+2 for a draw two,
 * Bs for a skip, Yr for a reverse, W for a wild and W4 for a wild draw four. Type play followed by a
 * card, adding a colour letter when you play a wild, as in play W r; or type draw to take a card.
 * First seat to empty its hand wins.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "play R5"] call AE3_games_fnc_rules_uno) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_deck, _hands per seat, _top card, _colour, _side, _direction, _lastKey, _result]

private _fnc_newDeck =
{
    private _deck = [];

    {
        private _colour = _x;

        _deck pushBack (_colour + "0");

        {
            private _value = _x;

            _deck pushBack (_colour + _value);
            _deck pushBack (_colour + _value);
        } forEach ["1", "2", "3", "4", "5", "6", "7", "8", "9", "s", "r", "+2"];
    } forEach ["R", "G", "B", "Y"];

    for "_i" from 1 to 4 do
    {
        _deck pushBack "W";
        _deck pushBack "W4";
    };

    private _shuffled = [];

    while {_deck isNotEqualTo []} do
    {
        private _index = floor (random (count _deck));

        _shuffled pushBack (_deck select _index);
        _deck deleteAt _index;
    };

    _shuffled
};

private _fnc_valueOf =
{
    params ["_card"];

    if (_card select [0, 1] isEqualTo "W") exitWith {_card};

    _card select [1]
};

// A card may be played on the top card when it shares the current colour or the same value, and a
// wild may always be played
private _fnc_playable =
{
    params ["_card", "_top", "_colour"];

    if (_card select [0, 1] isEqualTo "W") exitWith {true};
    if (_card select [0, 1] isEqualTo _colour) exitWith {true};

    ([_card] call _fnc_valueOf) isEqualTo ([_top] call _fnc_valueOf)
};

private _fnc_drawCard =
{
    params ["_deck"];

    if (_deck isEqualTo []) then
    {
        private _fresh = call _fnc_newDeck;

        {
            _deck pushBack _x;
        } forEach _fresh;
    };

    _deck deleteAt 0
};

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _seatCount = _this param [1, 2];
        private _deck = call _fnc_newDeck;
        private _hands = [];

        for "_seat" from 1 to _seatCount do
        {
            private _hand = [];

            for "_card" from 1 to 7 do {_hand pushBack (_deck deleteAt 0)};

            _hands pushBack _hand;
        };

        // The first card on the pile is a plain numbered one, so nobody is punished before their turn
        private _top = _deck deleteAt 0;

        while {!((_top select [0, 1]) in ["R", "G", "B", "Y"]) || !((_top select [1]) in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])} do
        {
            _deck pushBack _top;
            _top = _deck deleteAt 0;
        };

        [_deck, _hands, _top, _top select [0, 1], 0, 1, "", -1]
    };

    case "turn":
    {
        (_this param [1, []]) params [["_deck", []], ["_hands", []], ["_top", ""], ["_colour", ""], ["_side", 0], ["_direction", 1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        _side
    };

    case "winner": {(_this param [1, []]) param [7, -1]};

    case "view":
    {
        (_this param [1, []]) params [["_deck", []], ["_hands", []], ["_top", ""], ["_colour", ""], ["_side", 0], ["_direction", 1], ["_lastKey", ""]];

        private _seat = _this param [2, 0];

        // Only this seat's own cards are sent; the others are counts, and the deck stays on the server
        [_hands param [_seat, []], _hands apply {count _x}, _top, _colour, _side, _direction, _lastKey]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_deck", []], ["_hands", []], ["_top", ""], ["_colour", ""], ["_side", 0], ["_direction", 1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, [_deck, _hands, _top, _colour, _side, _direction, _lastKey, _result]]};

        // A player who runs out of time draws and passes
        private _newDeck = +_deck;
        private _newHands = [];

        {
            _newHands pushBack +_x;
        } forEach _hands;

        (_newHands select _side) pushBack ([_newDeck] call _fnc_drawCard);

        private _next = (_side + _direction + count _hands) mod (count _hands);

        [true, [_newDeck, _newHands, _top, _colour, _next, _direction, "$STR_AE3_Games_Status_TurnTimedOut", -1]]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_deck", []], ["_hands", []], ["_top", ""], ["_colour", ""], ["_side", 0], ["_direction", 1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};
        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _words = (_move splitString " ") select {_x isNotEqualTo ""};
        private _command = toLowerANSI (_words param [0, ""]);
        private _seatCount = count _hands;

        private _newDeck = +_deck;
        private _newHands = [];

        {
            _newHands pushBack +_x;
        } forEach _hands;

        if (_command in ["draw", "d"]) exitWith
        {
            (_newHands select _seat) pushBack ([_newDeck] call _fnc_drawCard);

            private _afterDraw = (_seat + _direction + (_seatCount * 8)) mod _seatCount;

            [true, [_newDeck, _newHands, _top, _colour, _afterDraw, _direction, "$STR_AE3_Games_Status_CardDrawn", -1], "$STR_AE3_Games_Status_CardDrawn"]
        };

        if !(_command in ["play", "p"]) exitWith {[false, _state, "$STR_AE3_Games_Status_PlayOrDraw"]};

        private _wanted = toUpperANSI (_words param [1, ""]);

        // Colour and skip letters are written in lower case on a card, the colour prefix in upper
        if (count _wanted > 1 && ((_wanted select [0, 1]) isNotEqualTo "W")) then
        {
            _wanted = (_wanted select [0, 1]) + toLowerANSI (_wanted select [1]);
        };

        private _hand = _newHands select _seat;
        private _index = _hand find _wanted;

        if (_index < 0) exitWith {[false, _state, "$STR_AE3_Games_Status_CardNotHeld"]};
        if !([_wanted, _top, _colour] call _fnc_playable) exitWith {[false, _state, "$STR_AE3_Games_Status_CardNotPlayable"]};

        private _isWild = (_wanted select [0, 1]) isEqualTo "W";
        private _newColour = _wanted select [0, 1];

        if (_isWild) then
        {
            private _chosen = toUpperANSI (_words param [2, ""]);

            if !(_chosen in ["R", "G", "B", "Y"]) exitWith {};

            _newColour = _chosen;
        };

        if (_isWild && !(_newColour in ["R", "G", "B", "Y"])) exitWith {[false, _state, "$STR_AE3_Games_Status_PickAColour"]};

        _hand deleteAt _index;

        private _value = [_wanted] call _fnc_valueOf;
        private _newDirection = _direction;
        private _step = 1;
        private _key = "$STR_AE3_Games_Status_CardPlayed";

        switch (_value) do
        {
            case "s":
            {
                _step = 2;
                _key = "$STR_AE3_Games_Status_SeatSkipped";
            };
            case "r":
            {
                // With two seats a reverse acts as a skip, as it does on a card table
                _newDirection = -_direction;
                _step = [1, 2] select (_seatCount isEqualTo 2);
                _key = "$STR_AE3_Games_Status_OrderReversed";
            };
            case "+2";
            case "W4":
            {
                private _count = [2, 4] select (_value isEqualTo "W4");
                private _victim = (_seat + (_direction * 1) + (_seatCount * 8)) mod _seatCount;

                for "_i" from 1 to _count do
                {
                    (_newHands select _victim) pushBack ([_newDeck] call _fnc_drawCard);
                };

                _step = 2;
                _key = "$STR_AE3_Games_Status_SeatDrew";
            };
            default {};
        };

        private _newResult = -1;

        if (_hand isEqualTo []) then
        {
            _newResult = _seat;
            _key = "$STR_AE3_Games_Status_HandEmpty";
        };

        private _next = (_seat + (_newDirection * _step) + (_seatCount * 8)) mod _seatCount;

        [true, [_newDeck, _newHands, _wanted, _newColour, _next, _newDirection, _key, _newResult], _key]
    };

    default {[]};
};
