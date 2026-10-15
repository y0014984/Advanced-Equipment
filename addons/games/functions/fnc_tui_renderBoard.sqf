// File: fnc_tui_renderBoard.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Draws a game's board as terminal text. Plain characters only, so it reads the same on
 * every terminal design and keyboard layout and costs the terminal's ordinary throttled output rather
 * than a pixel canvas. A board with two sides is turned around for the seat that plays from the other
 * end, so a player always sees their own pieces at the bottom, and what is drawn is only ever the
 * seat view the server sent - a hand or a fleet the seat may not see is not in it to draw. Client only.
 *
 * Arguments:
 * 0: _gameId <STRING> - Game id
 * 1: _view <ARRAY> - The seat view the server sent
 * 2: _seat <NUMBER> - Seat the board is drawn for
 *
 * Return Value:
 * Lines to print <ARRAY>
 *
 * Example:
 * [_computer, ["chess", _view, 0] call AE3_games_fnc_tui_renderBoard] call AE3_armaos_fnc_shell_stdout;
 *
 * Public: No
 */

params [["_gameId", "", [""]], ["_view", [], [[]]], ["_seat", 0, [0]]];

// Shared eight by eight grid, used by chess and checkers
private _fnc_squareBoard =
{
    params ["_board", "_flip"];

    if (count _board < 64) exitWith {[]};

    private _cells = _board splitString "";
    private _lines = ["", "    a b c d e f g h"];

    for "_row" from 0 to 7 do
    {
        private _boardRow = [_row, 7 - _row] select _flip;
        private _rankLabel = str (8 - _boardRow);
        private _line = format ["  %1 ", _rankLabel];

        for "_col" from 0 to 7 do
        {
            private _boardCol = [_col, 7 - _col] select _flip;

            _line = _line + (_cells select (_boardRow * 8 + _boardCol)) + " ";
        };

        _lines pushBack (_line + _rankLabel);
    };

    _lines pushBack "    a b c d e f g h";
    _lines pushBack "";
    _lines pushBack "  Capitals are white or kings, lower case is black.";

    _lines
};

switch (toLowerANSI _gameId) do
{
    case "chess":
    {
        [_view param [0, ""], _seat isEqualTo 1] call _fnc_squareBoard
    };

    case "checkers":
    {
        private _lines = [_view param [0, ""], _seat isEqualTo 1] call _fnc_squareBoard;

        _lines pushBack "  Move as two squares, c3d4; a jump is c3e5.";

        _lines
    };

    case "uno":
    {
        _view params [["_hand", []], ["_counts", []], ["_top", ""], ["_colour", ""]];

        private _lines = ["", format ["  Pile: %1    Colour in play: %2", _top, _colour], ""];

        _lines pushBack format ["  Your cards: %1", _hand joinString "  "];
        _lines pushBack "";

        {
            private _label = format ["  Seat %1: %2 cards", _forEachIndex + 1, _x];

            if (_forEachIndex isEqualTo _seat) then {_label = _label + "  (you)"};

            _lines pushBack _label;
        } forEach _counts;

        _lines pushBack "";
        _lines pushBack "  play <card>, a wild needs a colour: play W r";
        _lines pushBack "  draw takes a card and passes.";

        _lines
    };

    case "ludo":
    {
        _view params [["_tokens", []], ["", 0], ["_pendingRoll", 0]];

        private _lines = ["", "  Tokens: 0 is the yard, 57 is home", ""];

        {
            private _label = format ["  Seat %1: %2", _forEachIndex + 1, (_x apply {str _x}) joinString "  "];

            if (_forEachIndex isEqualTo _seat) then {_label = _label + "   (you)"};

            _lines pushBack _label;
        } forEach _tokens;

        _lines pushBack "";

        if (_pendingRoll > 0) then
        {
            _lines pushBack format ["  You rolled %1 - type the token number to move it.", _pendingRoll];
        }
        else
        {
            _lines pushBack "  roll to throw the die.";
        };

        _lines
    };

    case "snakesladders":
    {
        _view params [["_positions", []], ["", 0], ["_lastRoll", 0]];

        private _lines = ["", "  Squares", ""];

        {
            private _label = format ["  Seat %1: square %2", _forEachIndex + 1, _x];

            if (_forEachIndex isEqualTo _seat) then {_label = _label + "   (you)"};

            _lines pushBack _label;
        } forEach _positions;

        _lines pushBack "";

        if (_lastRoll > 0) then {_lines pushBack format ["  Last roll: %1", _lastRoll]};

        _lines pushBack "  roll to throw the die.";

        _lines
    };

    case "blackjack":
    {
        _view params [["_hands", []], ["_totals", []], ["_dealer", []], ["_dealerTotal", 0], ["_done", []], ["_scores", []], ["_side", -1]];

        private _lines = ["", format ["  Dealer: %1  (%2)", _dealer joinString " ", _dealerTotal], ""];

        {
            private _label = format ["  Seat %1: %2  (%3)  rounds won %4", _forEachIndex + 1, _x joinString " ", _totals param [_forEachIndex, 0], _scores param [_forEachIndex, 0]];

            if (_forEachIndex isEqualTo _seat) then {_label = _label + "   (you)"};
            if ((_done param [_forEachIndex, false]) isEqualTo true) then {_label = _label + "   done"};

            _lines pushBack _label;
        } forEach _hands;

        _lines pushBack "";

        if (_side isEqualTo -1) then
        {
            _lines pushBack "  The round is over - deal starts the next one.";
        }
        else
        {
            _lines pushBack "  hit takes a card, stand keeps your hand.";
        };

        _lines
    };

    case "rps":
    {
        _view params [["_own", ""], ["_opponentThrew", false], ["_scores", []], ["_round", 1], ["", ""], ["_lastThrows", ["", ""]], ["_lastWinner", -1]];

        private _lines = ["", format ["  Round %1    Score %2 - %3", _round, _scores param [0, 0], _scores param [1, 0]], ""];

        // What the previous round came down to, so a player sees what beat what rather than only the
        // score moving
        if ((_lastThrows param [0, ""]) isNotEqualTo "") then
        {
            private _outcome = "drawn";

            if (_lastWinner isEqualTo _seat) then {_outcome = "you won it"};
            if (_lastWinner >= 0 && (_lastWinner isNotEqualTo _seat)) then {_outcome = "they won it"};

            _lines pushBack format ["  Last round: you threw %1, they threw %2 - %3",
                _lastThrows param [_seat, ""], _lastThrows param [1 - _seat, ""], _outcome];
            _lines pushBack "";
        };

        _lines pushBack format ["  Your throw: %1", ["not yet", _own] select (_own isNotEqualTo "")];
        _lines pushBack format ["  Opponent: %1", ["not yet", "has thrown"] select (_opponentThrew isEqualTo true)];
        _lines pushBack "";
        _lines pushBack "  rock, paper or scissors. First to three wins.";

        _lines
    };

    case "battleship":
    {
        _view params [["_own", ""], ["_shots", ""], ["", 0], ["", ""], ["_phase", "play"], ["_fleet", []], ["_ownAfloat", 0], ["_enemyAfloat", 0], ["_ready", [false, false]]];

        if (count _own < 100) exitWith {[]};

        private _ownCells = _own splitString "";
        private _shotCells = _shots splitString "";
        private _lines = ["", "  Your waters            Their waters", "     a b c d e f g h i j      a b c d e f g h i j"];

        for "_row" from 0 to 9 do
        {
            private _label = format ["%1", _row + 1];

            if (count _label < 2) then {_label = " " + _label};

            private _left = "";
            private _right = "";

            for "_col" from 0 to 9 do
            {
                _left = _left + (_ownCells select (_row * 10 + _col)) + " ";
                _right = _right + (_shotCells select (_row * 10 + _col)) + " ";
            };

            _lines pushBack format ["  %1 %2   %3 %4", _label, _left, _label, _right];
        };

        _lines pushBack "";
        _lines pushBack format ["  Ships afloat - yours %1, theirs %2", _ownAfloat, _enemyAfloat];

        if (_phase isEqualTo "setup") then
        {
            // The fleet is still being laid out, so what is on screen is a yard rather than a target
            _lines pushBack "";
            _lines pushBack "  Your fleet:";

            {
                private _indices = _x param [1, []];
                private _where = "not placed";

                if (_indices isNotEqualTo []) then
                {
                    private _first = _indices param [0, 0];
                    private _heading = ["vertical", "horizontal"] select (((_indices param [1, _first]) - _first) isEqualTo 1);

                    _where = format ["%1%2 %3", "abcdefghij" select [_first mod 10, 1], floor (_first / 10) + 1, _heading];
                };

                _lines pushBack format ["    %1) length %2 - %3", _forEachIndex + 1, _x param [0, 0], _where];
            } forEach _fleet;

            _lines pushBack "";
            _lines pushBack "  place <ship> <square> <h|v> lays one out, random does the lot, clear empties the grid.";
            _lines pushBack format ["  ready starts the firing. Opponent %1.", ["is still placing", "is ready"] select ((_ready param [1 - _seat, false]) isEqualTo true)];
        }
        else
        {
            _lines pushBack "  S is your ship, x a hit, o a miss. Fire by naming a square, b5.";
        };

        _lines
    };

    default {[]};
};
