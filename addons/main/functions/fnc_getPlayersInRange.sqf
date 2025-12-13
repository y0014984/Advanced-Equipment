/*
 * Author: Root, y0014984
 * Description: Returns all players within a specified radius around the given object. Used for UI-on-Texture rendering to determine which clients need updates.
 *
 * Arguments:
 * 0: _range <NUMBER> - Search radius in meters
 * 1: _object <OBJECT> - Center object for the search
 *
 * Return Value:
 * Array of players <ARRAY> - Array of player objects within range
 *
 * Example:
 * private _nearbyPlayers = [50, _laptop] call AE3_main_fnc_getPlayersInRange;
 *
 * Public: Yes
 */

params ["_range", "_object"];

private _allPlayers = [] call BIS_fnc_listPlayers; // Only players, not headless clients

private _playersInRange = _allPlayers select {(_x distance _object) < _range};

_playersInRange;
