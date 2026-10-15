// File: fnc_joinTable.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Seats a device at an existing table, or hands back the seat it already holds, which
 * is how a match is resumed after the application was closed or the laptop was switched off. The
 * table starts as soon as its minimum number of seats is filled. Reachability is checked against the
 * host device, so a laptop on another network or out of wireless range cannot join. Runs on the
 * server; a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the joining device
 * 1: _tableId <STRING> - Table id
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3"] call AE3_games_fnc_joinTable;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]]];

if (!isServer) exitWith {["ae3_games_join", [_deviceNetId, _tableId]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, "$STR_AE3_Games_Status_NoSuchTable"] call FUNC(pushNotice)};

if !([_device, "Enabled"] call FUNC(getSetting)) exitWith {[_device, "$STR_AE3_Games_Status_Disabled"] call FUNC(pushNotice)};

// Already seated: this is a resume, not a join
if (([_table, _deviceNetId] call FUNC(seatOf)) >= 0) exitWith {[_tableId] call FUNC(pushState)};

// A seat is taken before the match starts, so a game dealt for the players at the table is not
// disturbed by someone sitting down halfway through
if ((_table getOrDefault ["phase", "lobby"]) isNotEqualTo "lobby") exitWith
{
    [_device, "$STR_AE3_Games_Status_AlreadyStarted"] call FUNC(pushNotice);
};

private _host = objectFromNetId (_table getOrDefault ["host", ""]);

if !([_device, _host] call FUNC(reachable)) exitWith {[_device, "$STR_AE3_Games_Status_Unreachable"] call FUNC(pushNotice)};

private _info = [_table getOrDefault ["gameId", ""]] call FUNC(gameInfo);

if (_info isEqualTo []) exitWith {};

_info params ["", "", "_maxSeats"];

private _seats = _table getOrDefault ["seats", []];

if (count _seats >= _maxSeats) exitWith {[_device, "$STR_AE3_Games_Status_TableFull"] call FUNC(pushNotice)};

// Lowest free seat index, so seats stay stable as players come and go
private _taken = _seats apply {_x select 1};
private _seat = -1;

for "_i" from 0 to (_maxSeats - 1) do
{
    if (_seat < 0 && {!(_i in _taken)}) then {_seat = _i};
};

if (_seat < 0) exitWith {[_device, "$STR_AE3_Games_Status_TableFull"] call FUNC(pushNotice)};

_seats pushBack [_deviceNetId, _seat, ""];
_table set ["seats", _seats];
_table set ["lastMoveAt", serverTime];

missionNamespace setVariable [QGVAR(tables), _tables];

// A full table has nobody left to wait for, so it starts itself; a table with room waits for the
// host to start it, which is what lets three people sit down at a four seat game
if (count _seats >= _maxSeats) exitWith
{
    [_table getOrDefault ["host", ""], _tableId] call FUNC(startTable);
};

[_tableId] call FUNC(pushState);
