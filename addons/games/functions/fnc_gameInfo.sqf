// File: fnc_gameInfo.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Describes a game by id: its rules function, how many seats it takes and its display
 * name. One table here is what both front ends, the lobby and the server validation read, so a game
 * is added by writing its rules function and adding a row rather than by touching the framework.
 *
 * Arguments:
 * 0: _gameId <STRING> - Game id, e.g. "chess"
 *
 * Return Value:
 * [_rules <CODE>, _minSeats <NUMBER>, _maxSeats <NUMBER>, _title <STRING>, _sideChoice <STRING>], or
 * [] when unknown <ARRAY>
 *
 * Example:
 * (["chess"] call AE3_games_fnc_gameInfo) params ["_rules", "_minSeats", "_maxSeats", "_title"];
 *
 * Public: Yes
 */

params [["_gameId", "", [""]]];

// Seat counts are [minimum to start, maximum the table holds]. The side choice names what the lobby
// offers before a match begins: "colour" lets each seat ask for a side and refuses to start until
// every request is a different one, "starter" lets the host name the seat that moves first, and
// "none" is for a game where both seats act at the same time and the order means nothing.
private _games = createHashMapFromArray
[
    ["chess", [2, 2, "$STR_AE3_Games_Title_Chess", "colour"]],
    ["checkers", [2, 2, "$STR_AE3_Games_Title_Checkers", "starter"]],
    ["uno", [2, 8, "$STR_AE3_Games_Title_Uno", "starter"]],
    ["ludo", [2, 4, "$STR_AE3_Games_Title_Ludo", "starter"]],
    ["snakesladders", [1, 4, "$STR_AE3_Games_Title_SnakesLadders", "starter"]],
    ["blackjack", [2, 8, "$STR_AE3_Games_Title_Blackjack", "starter"]],
    ["rps", [2, 2, "$STR_AE3_Games_Title_Rps", "none"]],
    ["battleship", [2, 2, "$STR_AE3_Games_Title_Battleship", "starter"]]
];

private _row = _games getOrDefault [toLowerANSI _gameId, []];

if (_row isEqualTo []) exitWith {[]};

_row params ["_minSeats", "_maxSeats", "_title", "_sideChoice"];

private _rules = missionNamespace getVariable [format ["AE3_games_fnc_rules_%1", toLowerANSI _gameId], {}];

if (_rules isEqualTo {}) exitWith {[]};

[_rules, _minSeats, _maxSeats, _title, _sideChoice]
