/**
 * Returns all players within a radius around the given object.
 *
 * Arguments:
 * 0: Range <NUMBER>
 * 1: Object <OBJECT>
 * 
 * Return:
 * Nothing
 */

params ["_range", "_object"];

private _allPlayers = [] call BIS_fnc_listPlayers; // Only players, not headless clients

private _playersInRange = [];
{
    if ((_x distance _object) < _range) then { _playersInRange pushBack _x; }; 
} forEach _allPlayers;

_playersInRange;