// File: fnc_gameIds.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Every game a computer can carry, in the order they are listed to a mission maker and
 * to a curator. Snake is ae3_armaos's own single player game and the rest are the networked ones, but
 * all of them are CfgGames classes and all of them install and uninstall the same way, so one list
 * serves the default install, the Add Games module and anything a mission script asks for.
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
