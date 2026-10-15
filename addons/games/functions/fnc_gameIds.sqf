// File: fnc_gameIds.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Every game a computer can carry, in the order they are listed to a mission maker and
 * to a curator. All of them are CfgGames classes and install the same way.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Game ids <ARRAY>
 *
 * Example:
 * [_computer, call AE3_games_fnc_gameIds] call AE3_games_fnc_installGames;
 *
 * Public: Yes
 */

["snake", "chess", "checkers", "uno", "ludo", "snakesladders", "blackjack", "rps", "battleship"]
