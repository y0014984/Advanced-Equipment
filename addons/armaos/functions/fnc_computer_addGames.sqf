/*
 * Author: Root, y0014984
 * Description: Adds selected games to a given computer. Currently only Snake is supported. Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to add games to
 * 1: _isSnake <BOOL> - Whether to add the Snake game
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, true] call AE3_armaos_fnc_computer_addGames;
 *
 * Public: Yes
 */

params ["_computer", "_isSnake"];

if (!isServer) exitWith {};

if (_isSnake) then
{
    //--- add all games to all synced computers
    [_computer, "CfgGames", ["snake"]] call AE3_armaos_fnc_link_init;
};
