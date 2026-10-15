// File: fnc_rules_blackjack.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Blackjack for up to eight seats against an automatic dealer, first seat to three
 * round wins takes the match. The shoe is shuffled and dealt on the server and the dealer's hole card
 * stays there until the round is resolved, so no client can read the next card or the card it is not
 * allowed to see. Type hit or stand on your turn, and deal to start the next round once one is over.
 * The dealer draws to seventeen.
 *
 * Arguments:
 * 0: _request <STRING> - "new", "turn", "apply", "view", "winner" or "timeout"
 * 1..: Request arguments, as described in AE3_games_fnc_rules_chess
 *
 * Return Value:
 * Depends on the request <ANY>
 *
 * Example:
 * (["apply", _state, 0, "hit"] call AE3_games_fnc_rules_blackjack) params ["_ok", "_newState"];
 *
 * Public: No
 */

params [["_request", "", [""]]];

// State: [_deck, _hands per seat, _dealer, _done per seat, _scores, _side, _lastKey, _result]

private _fnc_total =
{
    params ["_hand"];

    private _total = 0;
    private _aces = 0;

    {
        switch (_x) do
        {
            case "A": {_total = _total + 11; _aces = _aces + 1};
            case "K";
            case "Q";
            case "J": {_total = _total + 10};
            default {_total = _total + parseNumber _x};
        };
    } forEach _hand;

    // An ace counts as one when eleven would bust the hand
    while {_total > 21 && _aces > 0} do
    {
        _total = _total - 10;
        _aces = _aces - 1;
    };

    _total
};

private _fnc_newDeck =
{
    private _deck = [];

    {
        private _rank = _x;

        for "_i" from 1 to 4 do {_deck pushBack _rank};
    } forEach ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];

    // Shuffled on the server, where no client can look at it
    private _shuffled = [];

    while {_deck isNotEqualTo []} do
    {
        private _index = floor (random (count _deck));

        _shuffled pushBack (_deck select _index);
        _deck deleteAt _index;
    };

    _shuffled
};

// Deals a fresh round into an existing state
private _fnc_deal =
{
    params ["_seatCount", "_scores"];

    private _deck = call _fnc_newDeck;
    private _hands = [];
    private _done = [];

    for "_seat" from 1 to _seatCount do
    {
        private _hand = [_deck deleteAt 0, _deck deleteAt 0];

        _hands pushBack _hand;
        _done pushBack (([_hand] call _fnc_total) isEqualTo 21);
    };

    private _dealer = [_deck deleteAt 0, _deck deleteAt 0];
    private _side = _done findIf {!_x};

    // Everyone was dealt twenty one, so there is nobody to ask and the round resolves at once
    if (_side < 0) exitWith {[_deck, _hands, _dealer, _done, _scores] call _fnc_resolve};

    [_deck, _hands, _dealer, _done, _scores, _side, "$STR_AE3_Games_Status_Dealt", -1]
};

// Plays the dealer out and scores every seat
private _fnc_resolve =
{
    params ["_deck", "_hands", "_dealer", "_done", "_scores"];

    private _newDealer = +_dealer;
    private _newDeck = +_deck;

    while {([_newDealer] call _fnc_total) < 17} do
    {
        _newDealer pushBack (_newDeck deleteAt 0);
    };

    private _dealerTotal = [_newDealer] call _fnc_total;
    private _newScores = +_scores;

    {
        private _total = [_x] call _fnc_total;
        private _seat = _forEachIndex;

        if (_total <= 21) then
        {
            if (_dealerTotal > 21 || _total > _dealerTotal) then
            {
                _newScores set [_seat, (_newScores select _seat) + 1];
            };
        };
    } forEach _hands;

    private _result = -1;

    {
        if (_x >= 3) then {_result = _forEachIndex};
    } forEach _newScores;

    [_newDeck, _hands, _newDealer, _done, _newScores, -1, "$STR_AE3_Games_Status_RoundResolved", _result]
};

switch (toLowerANSI _request) do
{
    case "new":
    {
        private _seatCount = _this param [1, 2];
        private _scores = [];

        for "_i" from 1 to _seatCount do {_scores pushBack 0};

        [_seatCount, _scores] call _fnc_deal
    };

    case "turn":
    {
        (_this param [1, []]) params [["_deck", []], ["_hands", []], ["_dealer", []], ["_done", []], ["_scores", []], ["_side", -1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {-1};

        // A finished round takes a deal from any seat
        _side
    };

    case "winner": {(_this param [1, []]) param [7, -1]};

    case "view":
    {
        (_this param [1, []]) params [["_deck", []], ["_hands", []], ["_dealer", []], ["_done", []], ["_scores", []], ["_side", -1], ["_lastKey", ""]];

        private _seat = _this param [2, 0];
        private _resolved = _side isEqualTo -1;

        // Player hands are face up in blackjack, but the dealer's second card is not dealt to the
        // client until the round is over, and the shoe never leaves the server
        private _dealerShown = _dealer;

        if (!_resolved) then {_dealerShown = [_dealer param [0, ""]]};

        private _totals = _hands apply {[_x] call _fnc_total};

        [_hands, _totals, _dealerShown, [_dealerShown] call _fnc_total, _done, _scores, _side, _seat, _lastKey]
    };

    case "timeout":
    {
        (_this param [1, []]) params [["_deck", []], ["_hands", []], ["_dealer", []], ["_done", []], ["_scores", []], ["_side", -1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1 || _side isEqualTo -1) exitWith {[false, [_deck, _hands, _dealer, _done, _scores, _side, _lastKey, _result]]};

        // A player who runs out of time stands
        private _newDone = +_done;
        _newDone set [_side, true];

        private _next = _newDone findIf {!_x};

        if (_next >= 0) exitWith
        {
            [true, [_deck, _hands, _dealer, _newDone, _scores, _next, "$STR_AE3_Games_Status_TurnTimedOut", -1]]
        };

        [true, [_deck, _hands, _dealer, _newDone, _scores] call _fnc_resolve]
    };

    case "apply":
    {
        params ["", ["_state", []], ["_seat", 0], ["_move", ""]];

        _state params [["_deck", []], ["_hands", []], ["_dealer", []], ["_done", []], ["_scores", []], ["_side", -1], ["_lastKey", ""], ["_result", -1]];

        if (_result isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_GameOver"]};

        private _word = toLowerANSI (_move splitString " " joinString "");

        // Between rounds, any seat may deal the next one
        if (_word in ["deal", "d"]) exitWith
        {
            if (_side isNotEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_RoundInPlay"]};

            [true, [count _hands, _scores] call _fnc_deal, "$STR_AE3_Games_Status_Dealt"]
        };

        if (_side isEqualTo -1) exitWith {[false, _state, "$STR_AE3_Games_Status_DealToPlay"]};
        if (_seat isNotEqualTo _side) exitWith {[false, _state, "$STR_AE3_Games_Status_NotYourTurn"]};

        private _newHands = [];

        {
            _newHands pushBack +_x;
        } forEach _hands;

        private _newDeck = +_deck;
        private _newDone = +_done;
        private _key = "$STR_AE3_Games_Status_Stood";

        if (_word in ["hit", "h"]) then
        {
            private _hand = _newHands select _seat;

            _hand pushBack (_newDeck deleteAt 0);

            private _total = [_hand] call _fnc_total;

            _key = "$STR_AE3_Games_Status_Hit";

            if (_total >= 21) then
            {
                _newDone set [_seat, true];
                _key = ["$STR_AE3_Games_Status_Twenty", "$STR_AE3_Games_Status_Bust"] select (_total > 21);
            };
        }
        else
        {
            if !(_word in ["stand", "s"]) exitWith {};

            _newDone set [_seat, true];
        };

        if (_key isEqualTo "$STR_AE3_Games_Status_Stood" && !(_newDone select _seat)) exitWith
        {
            [false, _state, "$STR_AE3_Games_Status_HitOrStand"]
        };

        private _next = _newDone findIf {!_x};

        if (_next >= 0) exitWith
        {
            [true, [_newDeck, _newHands, _dealer, _newDone, _scores, _next, _key, -1], _key]
        };

        // Everyone is done, so the dealer plays and the round is scored
        [true, [_newDeck, _newHands, _dealer, _newDone, _scores] call _fnc_resolve, "$STR_AE3_Games_Status_RoundResolved"]
    };

    default {[]};
};
