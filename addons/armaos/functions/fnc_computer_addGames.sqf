params ["_computer", "_isSnake"];

if (_isSnake) then
{
    //--- add all games to all synced computers
    [_computer, "CfgGames", ["snake"]] call AE3_armaos_fnc_link_init;
};