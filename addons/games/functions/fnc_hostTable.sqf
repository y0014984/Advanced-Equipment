// File: fnc_hostTable.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Opens a new table on a device and seats that device first. The table lives on the
 * server for the rest of the mission unless it is closed or abandoned, so the match survives the
 * player closing the desktop, switching the laptop off or reconnecting. Runs on the server; a client
 * call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the hosting device
 * 1: _gameId <STRING> - Game id, see AE3_games_fnc_gameInfo
 * 2: _name <STRING> (Optional) - Name the table is listed under, blank for the game's own title
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess", "Officers only"] call AE3_games_fnc_hostTable;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_gameId", "", [""]], ["_name", "", [""]]];

if (!isServer) exitWith {["ae3_games_host", [_deviceNetId, _gameId, _name]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _info = [_gameId] call FUNC(gameInfo);

if (_info isEqualTo []) exitWith {};

_info params ["_rules", "", "_maxSeats"];

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];

if (!([_device, "Enabled"] call FUNC(getSetting)) || {!([_device, "AllowHosting"] call FUNC(getSetting))}) exitWith
{
    [_device, "$STR_AE3_Games_Status_Disabled"] call FUNC(pushNotice);
};

if (count _tables >= ([_device, "MaxTables"] call FUNC(getSetting))) exitWith
{
    [_device, "$STR_AE3_Games_Status_TooManyTables"] call FUNC(pushNotice);
};

// One table per device per game, so a second Host press resumes rather than piling up tables
private _existing = "";

{
    private _candidate = _y;

    if ((_candidate getOrDefault ["gameId", ""]) isEqualTo _gameId && {([_candidate, _deviceNetId] call FUNC(seatOf)) >= 0}) then
    {
        _existing = _x;
    };
} forEach _tables;

if (_existing isNotEqualTo "") exitWith {[_existing] call FUNC(pushState)};

private _counter = (missionNamespace getVariable [QGVAR(idCounter), 0]) + 1;
missionNamespace setVariable [QGVAR(idCounter), _counter];

private _tableId = format ["%1-%2", _gameId, _counter];

private _table = createHashMapFromArray
[
    ["gameId", _gameId],
    ["host", _deviceNetId],
    // A name the host typed is what the lobby lists, so a table is told apart from the other three
    // games of chess on the network rather than by its number
    ["name", _name select [0, 40]],
    ["seats", [[_deviceNetId, 0, ""]]],
    // Which of the seats a device holds it is playing, and what side each seat asked for before the
    // match was built - both are settled in the lobby and read once, when the table starts
    ["active", createHashMap],
    ["prefs", createHashMap],
    ["starter", -1],
    ["open", []],
    ["state", ["new", _maxSeats] call _rules],
    ["turn", 0],
    ["phase", "lobby"],
    ["winner", -1],
    ["status", ""],
    ["createdAt", serverTime],
    ["lastMoveAt", serverTime]
];

_tables set [_tableId, _table];
missionNamespace setVariable [QGVAR(tables), _tables];

[] call FUNC(manageSweep);

[_tableId] call FUNC(pushState);
