/**
 * PUBLIC
 *
 * Adds selected games to a given computer. Currently only Snake supported.
 * Needs to run on server.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Snake <BOOL>
 *
 * Results:
 * None
 *
 * Example:
 * [_computer, true] call AE3_armaos_fnc_computer_addGames;
 *
 */

params ["_computer", "_isSnake"];

if (!isServer) exitWith {};

if (_isSnake) then
{
    //--- add all games to all synced computers
    [_computer, "CfgGames", ["snake"]] call AE3_armaos_fnc_link_init;
};
