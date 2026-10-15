// File: fnc_seatOf.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the seat a device is currently playing at a table. A seat belongs to the
 * device rather than to a player, which is what lets a match be picked up again by whoever is at that
 * laptop after the desktop was closed, the laptop was switched off or the player reconnected. A
 * device holding more than one seat plays the one it last switched to, and falls back to the lowest
 * it holds when it has not switched.
 *
 * Arguments:
 * 0: _table <HASHMAP> - Table state
 * 1: _deviceNetId <STRING> - Network id of the device
 *
 * Return Value:
 * Seat index, or -1 when the device holds no seat <NUMBER>
 *
 * Example:
 * private _seat = [_table, netId _computer] call AE3_games_fnc_seatOf;
 *
 * Public: No
 */

params [["_table", createHashMap, [createHashMap]], ["_deviceNetId", "", [""]]];

private _held = [_table, _deviceNetId] call FUNC(seatsOf);

if (_held isEqualTo []) exitWith {-1};

private _active = (_table getOrDefault ["active", createHashMap]) getOrDefault [_deviceNetId, -1];

if (_active in _held) exitWith {_active};

_held select 0
