// File: fnc_tableSweep.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Periodic housekeeping for live tables: it drops a table whose device has been deleted,
 * closes one that has seen no move for longer than the abandonment timeout, and passes the turn on
 * when a turn timeout is set and has run out. It deliberately does not touch a seat whose player
 * closed the game, walked away, died, disconnected or switched the laptop off - that is a suspended
 * seat, not an abandoned one. Registered and removed by AE3_games_fnc_manageSweep, so it only runs
 * while at least one table exists. Server only.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_games_fnc_tableSweep;
 *
 * Public: No
 */

if (!isServer) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _abandon = [objNull, "AbandonTimeout"] call FUNC(getSetting);
private _turnTimeout = [objNull, "TurnTimeout"] call FUNC(getSetting);
private _now = serverTime;

private _toClose = [];

{
    private _tableId = _x;
    private _table = _y;

    // A seat whose device no longer exists can never come back
    private _seats = (_table getOrDefault ["seats", []]) select {!isNull (objectFromNetId (_x select 0))};

    if (count _seats isNotEqualTo count (_table getOrDefault ["seats", []])) then
    {
        _table set ["seats", _seats];
        _table set ["open", (_table getOrDefault ["open", []]) select {!isNull (objectFromNetId _x)}];
    };

    private _lastMoveAt = _table getOrDefault ["lastMoveAt", _now];

    if (_seats isEqualTo []) then
    {
        _toClose pushBack [_tableId, "$STR_AE3_Games_Status_Closed"];
    }
    else
    {
        if (_abandon > 0 && {(_now - _lastMoveAt) > _abandon}) then
        {
            _toClose pushBack [_tableId, "$STR_AE3_Games_Status_Abandoned"];
        }
        else
        {
            // Turn timeout only exists when a mission asks for one
            if (_turnTimeout > 0 && {(_table getOrDefault ["phase", "lobby"]) isEqualTo "play"} && {(_now - _lastMoveAt) > _turnTimeout}) then
            {
                private _info = [_table getOrDefault ["gameId", ""]] call FUNC(gameInfo);

                if (_info isNotEqualTo []) then
                {
                    _info params ["_rules"];

                    (["timeout", _table getOrDefault ["state", []]] call _rules) params [["_ok", false], ["_newState", []]];

                    if (_ok) then
                    {
                        _table set ["state", _newState];
                        _table set ["turn", ["turn", _newState] call _rules];
                        _table set ["winner", ["winner", _newState] call _rules];
                        _table set ["status", "$STR_AE3_Games_Status_TurnTimedOut"];
                        _table set ["lastMoveAt", _now];

                        if ((_table getOrDefault ["winner", -1]) != -1) then {_table set ["phase", "over"]};

                        [_tableId] call FUNC(pushState);
                    };
                };
            };
        };
    };
} forEach _tables;

missionNamespace setVariable [QGVAR(tables), _tables];

{
    _x params ["_tableId", "_reasonKey"];

    [_tableId, _reasonKey] call FUNC(closeTable);
} forEach _toClose;
