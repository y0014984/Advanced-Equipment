// File: fnc_zeus_games.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: The Zeus Games module. It asks the server for the live tables and the mission-wide
 * settings, then opens a dialog on the curator's own machine where those settings can be changed for
 * the session and a table can be closed. A value left empty keeps whatever the mission setting says,
 * which is how a curator hands control back. Settings written here beat the CBA setting and are in
 * turn beaten by a value set on a single device, in Eden or on that device itself.
 *
 * Arguments:
 * 0: _logic <OBJECT> - Module logic
 * 1: _units <ARRAY> - Synced units, unused
 * 2: _activated <BOOL> - Whether the module is activated
 *
 * Return Value:
 * None
 *
 * Example:
 * [_logic, [], true] call AE3_games_fnc_zeus_games;
 *
 * Public: No
 */

params [["_logic", objNull, [objNull]], ["_units", [], [[]]], ["_activated", true, [true]]];

// The module runs on every machine, but the dialog belongs to the curator who placed it
if (!_activated || !hasInterface || {!local _logic}) exitWith {};

if (isServer) then {deleteVehicle _logic} else {[_logic] remoteExecCall ["deleteVehicle", 2]};

[clientOwner, player] call FUNC(getRoster);
