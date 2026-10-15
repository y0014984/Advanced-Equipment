// File: fnc_removeGames.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Takes the terminal front ends of one or more games off a computer: the command link
 * goes, so the shell no longer knows the name, and the file it pointed at goes with it, so the game
 * is not sitting in /games for anyone to find either. A computer is given every game when it starts
 * up, which makes this the other half of the Add Games module - unticking a game is what calls it.
 * Runs on the server; a client call is routed there.
 *
 * Arguments:
 * 0: _device <OBJECT> - Computer to take the games off
 * 1: _gameIds <ARRAY> - Game ids, see AE3_games_fnc_gameIds
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["uno", "blackjack"]] call AE3_games_fnc_removeGames;
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_gameIds", [], [[]]]];

if (isNull _device) exitWith {};
if (_gameIds isEqualTo []) exitWith {};

if (!isServer) exitWith {["ae3_games_remove", [_device, _gameIds]] call CBA_fnc_serverEvent};

private _links = _device getVariable ["AE3_Links", createHashMap];
private _filesystem = _device getVariable "AE3_filesystem";

{
    private _class = configFile >> "CfgGames" >> _x;

    if (isClass _class) then
    {
        _links deleteAt (configName _class);

        // The device may never have been given the game, in which case there is no file to drop
        if (!isNil "_filesystem") then
        {
            try
            {
                [[], _filesystem, getText (_class >> "path"), "root"] call AE3_filesystem_fnc_delObj;
            }
            catch {};
        };
    };
} forEach _gameIds;

_device setVariable ["AE3_Links", _links, true];

if (!isNil "_filesystem") then
{
    _device setVariable ["AE3_filesystem", _filesystem, true];
};
