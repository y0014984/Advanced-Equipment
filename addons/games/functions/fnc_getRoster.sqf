// File: fnc_getRoster.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Answers a curator with every live table and the mission-wide settings, so the Games
 * module can show what is running and what the rules of the session are. Only a curator is answered,
 * because a roster names the computers people are playing on. Board contents are never included -
 * the roster is about tables, not about hands. Runs on the server; a client call is routed there.
 *
 * Arguments:
 * 0: _owner <NUMBER> - Machine network id to answer
 * 1: _curator <OBJECT> - Unit asking, which has to hold a curator logic
 *
 * Return Value:
 * None
 *
 * Example:
 * [clientOwner, player] call AE3_games_fnc_getRoster;
 *
 * Public: No
 */

params [["_owner", 0, [0]], ["_curator", objNull, [objNull]]];

if (!isServer) exitWith {["ae3_games_roster", [clientOwner, player]] call CBA_fnc_serverEvent};

// A hosted game runs the curator's own client on the server, so the request arrives with no round
// trip and clientOwner is this machine
if (_owner isEqualTo 0 && hasInterface) then {_owner = clientOwner};

if (_owner <= 0) exitWith {};

// A table roster tells a reader which computers are in use, so it goes to curators only
private _isCurator = (getAssignedCuratorLogic _curator) isNotEqualTo objNull;

if (!_isCurator) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _rows = [];

{
    private _table = _y;
    private _info = [_table getOrDefault ["gameId", ""]] call FUNC(gameInfo);

    if (_info isNotEqualTo []) then
    {
        _info params ["", "", "_maxSeats", "_title"];

        private _seats = _table getOrDefault ["seats", []];

        // A table the host named is listed under that name, which is what the players see too
        private _label = _table getOrDefault ["name", ""];

        if (_label isEqualTo "") then {_label = _title};

        _rows pushBack
        [
            _x,
            _label,
            _table getOrDefault ["phase", "lobby"],
            count _seats,
            _maxSeats,
            (_seats apply {
                private _label = _x param [2, ""];

                if (_label isEqualTo "") then {_label = [objectFromNetId (_x select 0)] call FUNC(deviceLabel)};

                _label
            }) joinString ", ",
            round (serverTime - (_table getOrDefault ["lastMoveAt", serverTime]))
        ];
    };
} forEach _tables;

private _settings = [];

{
    _settings pushBack [_x, [objNull, _x] call FUNC(getSetting)];
} forEach ["Enabled", "AllowHosting", "RequireSameNetwork", "GraphicalUI", "DebugSeats", "MaxTables", "TurnTimeout", "AbandonTimeout", "PowerDraw", "IdleDraw"];

["ae3_games_rosterResult", [_rows, _settings], _owner] call CBA_fnc_ownerEvent;
