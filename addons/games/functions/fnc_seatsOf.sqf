// File: fnc_seatsOf.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns every seat a device holds at a table, in seat order. A device normally holds
 * one, but a host testing a game on its own can be given extra practice seats, and those are driven
 * from the same laptop, so the seat a request belongs to has to be chosen out of this list rather
 * than assumed.
 *
 * Arguments:
 * 0: _table <HASHMAP> - Table state
 * 1: _deviceNetId <STRING> - Network id of the device
 *
 * Return Value:
 * Seat indices held by the device, lowest first <ARRAY>
 *
 * Example:
 * private _seats = [_table, netId _computer] call AE3_games_fnc_seatsOf;
 *
 * Public: No
 */

params [["_table", createHashMap, [createHashMap]], ["_deviceNetId", "", [""]]];

private _held = ((_table getOrDefault ["seats", []]) select {(_x select 0) isEqualTo _deviceNetId}) apply {_x select 1};

_held sort true;

_held
