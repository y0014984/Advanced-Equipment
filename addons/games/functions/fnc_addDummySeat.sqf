// File: fnc_addDummySeat.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Gives the hosting device an extra seat at its own table, so a game that needs two or
 * more players can be set up and played through from a single laptop while a mission is being built
 * or a rule is being checked. The seat is an ordinary seat in every way: it takes its turn, it only
 * ever sees its own cards and the device switches between the seats it holds. It is off by default
 * and gated by its own setting, because a table on a live network should not be able to deal itself
 * extra hands. Runs on the server; a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the hosting device
 * 1: _tableId <STRING> - Table id
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3"] call AE3_games_fnc_addDummySeat;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]]];

if (!isServer) exitWith {["ae3_games_dummy", [_deviceNetId, _tableId]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, "$STR_AE3_Games_Status_NoSuchTable"] call FUNC(pushNotice)};

if !([_device, "DebugSeats"] call FUNC(getSetting)) exitWith
{
    [_device, "$STR_AE3_Games_Status_DebugSeatsOff"] call FUNC(pushNotice);
};

if ((_table getOrDefault ["host", ""]) isNotEqualTo _deviceNetId) exitWith
{
    [_device, "$STR_AE3_Games_Status_HostOnly"] call FUNC(pushNotice);
};

if ((_table getOrDefault ["phase", "lobby"]) isNotEqualTo "lobby") exitWith
{
    [_device, "$STR_AE3_Games_Status_AlreadyStarted"] call FUNC(pushNotice);
};

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

_seats pushBack [_deviceNetId, _seat, format ["%1 %2", localize "STR_AE3_Games_Seat_Practice", _seat + 1]];

_table set ["seats", _seats];
_table set ["lastMoveAt", serverTime];

missionNamespace setVariable [QGVAR(tables), _tables];

[_tableId] call FUNC(pushState);
