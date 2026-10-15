// File: fnc_leaveTable.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Gives up a device's seat at a table. This is the deliberate way out - closing the
 * application, switching the laptop off or disconnecting all leave the seat alone so the match can be
 * resumed. The table is dropped once nobody is sitting at it. Runs on the server; a client call is
 * routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the leaving device
 * 1: _tableId <STRING> - Table id
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3"] call AE3_games_fnc_leaveTable;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]]];

if (!isServer) exitWith {["ae3_games_leave", [_deviceNetId, _tableId]] call CBA_fnc_serverEvent};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {};

// Every seat the device held goes, practice seats included, along with the side each of them had
// asked for and the note of which one the device was playing
private _held = [_table, _deviceNetId] call FUNC(seatsOf);
private _seats = (_table getOrDefault ["seats", []]) select {(_x select 0) isNotEqualTo _deviceNetId};
private _prefs = _table getOrDefault ["prefs", createHashMap];
private _active = _table getOrDefault ["active", createHashMap];

{
    _prefs deleteAt (str _x);
} forEach _held;

_active deleteAt _deviceNetId;

_table set ["seats", _seats];
_table set ["prefs", _prefs];
_table set ["active", _active];
_table set ["open", (_table getOrDefault ["open", []]) - [_deviceNetId]];
_table set ["status", "$STR_AE3_Games_Status_SeatLeft"];

// The player who left no longer draws power for a game they are not in
private _device = objectFromNetId _deviceNetId;

if (!isNull _device) then
{
    [_device, 0] call FUNC(applyGamePowerLoad);
};

if (_seats isEqualTo []) exitWith
{
    _tables deleteAt _tableId;
    missionNamespace setVariable [QGVAR(tables), _tables];

    [] call FUNC(manageSweep);
};

missionNamespace setVariable [QGVAR(tables), _tables];

[_tableId] call FUNC(pushState);
