// File: fnc_setActiveSeat.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Picks which of the seats a device holds it is playing. A laptop normally holds one
 * seat and never calls this; a host that gave itself practice seats uses it to take the other side
 * of the board, and every later move, and the view that is pushed back, follow the seat chosen here.
 * Runs on the server; a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the device
 * 1: _tableId <STRING> - Table id
 * 2: _seat <NUMBER> - Seat to play, which the device must already hold
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3", 1] call AE3_games_fnc_setActiveSeat;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]], ["_seat", -1, [0]]];

if (!isServer) exitWith {["ae3_games_seat", [_deviceNetId, _tableId, _seat]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, "$STR_AE3_Games_Status_NoSuchTable"] call FUNC(pushNotice)};

if !(_seat in ([_table, _deviceNetId] call FUNC(seatsOf))) exitWith
{
    [_device, "$STR_AE3_Games_Status_NotSeated"] call FUNC(pushNotice);
};

private _active = _table getOrDefault ["active", createHashMap];

_active set [_deviceNetId, _seat];
_table set ["active", _active];

missionNamespace setVariable [QGVAR(tables), _tables];

[_tableId] call FUNC(pushState);
