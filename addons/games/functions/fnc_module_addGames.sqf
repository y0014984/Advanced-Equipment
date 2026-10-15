// File: fnc_module_addGames.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: The Add Games module, for Eden and for Zeus. A computer is given every game when it
 * starts up, so what the checkboxes decide is which of them it keeps: a ticked game is installed and
 * an unticked one is taken off. Placed in Eden it applies to every synced computer; placed by a
 * curator it applies to the computer it was dropped on, asking through a Zeus Enhanced dialog or
 * leaving the full set alone when Zeus Enhanced is not loaded. This is the terminal side only; the
 * desktop apps follow the computer's own Games attribute instead.
 *
 * Arguments:
 * 0: _module <OBJECT> - Module logic
 * 1: _syncedUnits <ARRAY> - Synced computers
 * 2: _activated <BOOL> - Module activation state
 *
 * Return Value:
 * None
 *
 * Example:
 * [_module, [_laptop], true] call AE3_games_fnc_module_addGames;
 *
 * Public: No
 */

params [["_module", objNull, [objNull]], ["_syncedUnits", [], [[]]], ["_activated", true, [true]]];

if (isNull _module || !_activated) exitWith {};

// Checkbox property name on the module, paired with the game it decides. Snake is ae3_armaos's own
// single player game and the rest are the networked ones, but all of them are CfgGames classes, so
// one path covers the lot.
private _games =
[
    ["AE3_AddGames_Snake", "snake", "STR_AE3_Games_Config_AddGamesSnake"],
    ["AE3_AddGames_Chess", "chess", "STR_AE3_Games_Title_Chess"],
    ["AE3_AddGames_Checkers", "checkers", "STR_AE3_Games_Title_Checkers"],
    ["AE3_AddGames_Uno", "uno", "STR_AE3_Games_Title_Uno"],
    ["AE3_AddGames_Ludo", "ludo", "STR_AE3_Games_Title_Ludo"],
    ["AE3_AddGames_SnakesLadders", "snakesladders", "STR_AE3_Games_Title_SnakesLadders"],
    ["AE3_AddGames_Blackjack", "blackjack", "STR_AE3_Games_Title_Blackjack"],
    ["AE3_AddGames_Rps", "rps", "STR_AE3_Games_Title_Rps"],
    ["AE3_AddGames_Battleship", "battleship", "STR_AE3_Games_Title_Battleship"]
];

// The whole list is settled in one pass rather than only the ticked half, because a computer already
// has every game by the time this runs. Installing waits for the computer to finish initialising:
// reaching the link setup before the virtual filesystem exists fails on every file it creates.
private _fnc_apply =
{
    params ["_computers", "_wanted", "_all"];

    private _unwanted = _all - _wanted;

    {
        private _computer = _x;

        if (isClass (configOf _computer >> "AE3_Device")) then
        {
            if (_wanted isNotEqualTo []) then {[_computer, _wanted] call FUNC(installGames)};
            if (_unwanted isNotEqualTo []) then {[_computer, _unwanted] call FUNC(removeGames)};
        };
    } forEach _computers;
};

private _ids = _games apply {_x select 1};

private _curatorPlaced = _module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false];

/* ---------------------------------------- */

// Eden: the checkboxes are already on the module, and the server installs on every synced computer
if (!_curatorPlaced) exitWith
{
    if (!isServer) exitWith {};

    private _wanted = [];

    {
        _x params ["_property", "_gameId"];

        // A checkbox nobody touched is ticked, so a module dropped and left alone changes nothing
        if ((_module getVariable [_property, true]) isEqualTo true) then {_wanted pushBack _gameId};
    } forEach _games;

    [_syncedUnits, _wanted, _ids] call _fnc_apply;

    deleteVehicle _module;
};

/* ---------------------------------------- */

// Zeus: only the curator's own machine goes on, because that is where the dialog belongs
if (!local _module) exitWith {};

// A curator drops the module onto the computer it is meant for
private _computer = _module getVariable ["BIS_fnc_moduleInit_target", objNull];

if (isNull _computer) then
{
    private _nearby = (nearestObjects [getPosATL _module, [], 15]) select {isClass (configOf _x >> "AE3_Device")};

    _computer = _nearby param [0, objNull];
};

if (isServer) then {deleteVehicle _module} else {[_module] remoteExecCall ["deleteVehicle", 2]};

if (isNull _computer) exitWith
{
    [objNull, localize "STR_AE3_Main_Zeus_NoComputer"] call BIS_fnc_showCuratorFeedbackMessage;
};

// Without Zeus Enhanced there is no dialog to ask with, so the computer keeps the lot
if (isNil "zen_dialog_fnc_create") exitWith
{
    [[_computer], _ids, _ids] call _fnc_apply;

    [objNull, localize "STR_AE3_Games_Zeus_AllGamesAdded"] call BIS_fnc_showCuratorFeedbackMessage;
};

private _rows = _games apply
{
    _x params ["", "", "_labelKey"];

    ["CHECKBOX", [localize _labelKey], true]
};

[
    localize "STR_AE3_Games_Config_ModuleAddGamesDisplayName",
    _rows,
    {
        params ["_result", "_arguments"];

        _arguments params ["_computer", "_ids", "_fnc_apply"];

        private _wanted = [];

        {
            if (_x isEqualTo true) then {_wanted pushBack (_ids select _forEachIndex)};
        } forEach _result;

        [[_computer], _wanted, _ids] call _fnc_apply;

        [objNull, localize "STR_AE3_Games_Zeus_GamesAdded"] call BIS_fnc_showCuratorFeedbackMessage;
    },
    {},
    [_computer, _ids, _fnc_apply]
] call zen_dialog_fnc_create;
