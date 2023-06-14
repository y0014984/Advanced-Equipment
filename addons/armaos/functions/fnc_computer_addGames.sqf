/**
 * PUBLIC
 *
 * Adds selected games to a given computer. Currently only Snake supported.
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

if (_isSnake) then
{
    //--- add all games to all synced computers
    [_computer, "CfgGames", ["snake"]] call AE3_armaos_fnc_link_init;
};
