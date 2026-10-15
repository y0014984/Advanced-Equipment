// File: fnc_registerApps.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Puts the games into the web desktop. Each game is one external app of the script kind,
 * so the whole user interface is a single JS bundle loaded from this addon's own PBO and AE3 needs no
 * knowledge of it; the apps share that bundle and are told apart by their game id. The browser talks
 * back through commands registered here rather than through the core router, and each command does
 * nothing but hand the request to the server with the computer it came from. Registration is local
 * effect, so this runs on every client. Client only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_games_fnc_registerApps;
 *
 * Public: No
 */

if (!hasInterface) exitWith {};

private _script = "\z\ae3\addons\games\ui\web\js\ae3games.js";

// The browser never holds authority: every one of these just forwards to the server, which decides
{
    _x params ["_cmd", "_handler"];

    [_cmd, _handler] call AE3_desktop_fnc_registerCmd;
} forEach
[
    ["games_list", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["gameId", ""]] call AE3_games_fnc_getTables;
    }],
    ["games_host", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["gameId", ""], _data getOrDefault ["name", ""]] call AE3_games_fnc_hostTable;
    }],
    ["games_join", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""]] call AE3_games_fnc_joinTable;
    }],
    ["games_start", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""]] call AE3_games_fnc_startTable;
    }],
    ["games_leave", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""]] call AE3_games_fnc_leaveTable;
    }],
    ["games_move", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""], _data getOrDefault ["move", ""], clientOwner] call AE3_games_fnc_applyMove;
    }],
    ["games_open", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""], _data getOrDefault ["open", false]] call AE3_games_fnc_setGameOpen;
    }],
    ["games_option", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""], _data getOrDefault ["option", ""], _data getOrDefault ["value", ""]] call AE3_games_fnc_setTableOption;
    }],
    ["games_seat", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""], _data getOrDefault ["seat", -1]] call AE3_games_fnc_setActiveSeat;
    }],
    ["games_dummy", {
        params ["_computer", "", "_data"];

        [netId _computer, _data getOrDefault ["id", ""]] call AE3_games_fnc_addDummySeat;
    }]
];

// One entry per game. requiresVar hides the app on a computer where games are switched off, so an
// excluded device has no games on it rather than an app that refuses to do anything.
{
    _x params ["_gameId", "_title", "_glyph"];

    [
        format ["AE3_Game_%1", _gameId],
        _title,
        _glyph,
        "script",
        createHashMapFromArray
        [
            ["menu", "Games & Entertainment"],
            ["scriptPath", _script],
            ["factory", "AE3_makeGameApp"],
            ["gameId", _gameId],
            ["width", 880],
            ["height", 760],
            ["requiresVar", [QGVAR(enabled), true]]
        ]
    ] call AE3_desktop_fnc_registerExtApp;
} forEach
[
    // Every icon is a plain symbol character: a rook, a disc, two card suits, two dice, a cycle and
    // a grid. Anything that needs the emoji font - a playing card, a raised hand, an anchor - comes
    // out as an empty box on the laptop browser, which never falls back that far.
    ["chess", localize "STR_AE3_Games_Title_Chess", "&#9814;"],
    ["checkers", localize "STR_AE3_Games_Title_Checkers", "&#9679;"],
    ["uno", localize "STR_AE3_Games_Title_Uno", "&#9830;"],
    ["ludo", localize "STR_AE3_Games_Title_Ludo", "&#9856;"],
    ["snakesladders", localize "STR_AE3_Games_Title_SnakesLadders", "&#9860;"],
    ["blackjack", localize "STR_AE3_Games_Title_Blackjack", "&#9824;"],
    ["rps", localize "STR_AE3_Games_Title_Rps", "&#8635;"],
    ["battleship", localize "STR_AE3_Games_Title_Battleship", "&#9638;"]
];
