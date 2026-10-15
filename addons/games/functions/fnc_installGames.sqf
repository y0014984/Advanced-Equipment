// File: fnc_installGames.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Installs the terminal front ends of one or more games on a computer, through the same
 * link mechanism the stock terminal games use, so they appear under /games and in the shell's command
 * list. The desktop front end needs no installation - it is offered by the device's own settings. The
 * computer has to have a terminal, so the call waits for the device to finish initialising. Runs on
 * the server; a client call is routed there.
 *
 * Arguments:
 * 0: _device <OBJECT> - Computer to install on
 * 1: _gameIds <ARRAY> (Optional, default: every game) - Game ids, see AE3_games_fnc_gameIds
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["chess"]] call AE3_games_fnc_installGames;
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_gameIds", call FUNC(gameIds), [[]]]];

if (isNull _device) exitWith {};
if (_gameIds isEqualTo []) exitWith {};

if (!isServer) exitWith {["ae3_games_install", [_device, _gameIds]] call CBA_fnc_serverEvent};

// The links are files, so the wait covers the virtual filesystem as well as the terminal: installing
// before the filesystem exists fails on every file it tries to create.
[
    {
        params ["_device"];

        isNull _device || {(_device getVariable ["AE3_cap_hasTerminal", false]) && {!isNil {_device getVariable "AE3_filesystem"}}}
    },
    {
        params ["_device", "_gameIds"];

        if (isNull _device) exitWith {};

        // A computer that was built with its games already linked is the normal case, and adding a
        // link twice throws, so only the games it does not already have are asked for
        private _links = _device getVariable ["AE3_Links", createHashMap];
        private _missing = _gameIds select {!(_x in _links)};

        if (_missing isEqualTo []) exitWith {};

        [_device, "CfgGames", _missing] call AE3_armaos_fnc_link_init;
    },
    [_device, _gameIds]
] call CBA_fnc_waitUntilAndExecute;
