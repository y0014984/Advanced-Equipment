// File: fnc_setGameOpen.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Records that a device has a game open or has just closed it. Closing is not leaving:
 * the seat and the match stay exactly as they were so they can be picked up again. What does change
 * is the power the device draws - the full game draw while it is open, the much smaller parked draw
 * while the seat sits idle - and whether the server has anyone to push moves to. Runs on the server;
 * a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the device
 * 1: _tableId <STRING> - Table id
 * 2: _isOpen <BOOL> - True when the game is on screen on that device
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3", true] call AE3_games_fnc_setGameOpen;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]], ["_isOpen", false, [false]]];

if (!isServer) exitWith {["ae3_games_open", [_deviceNetId, _tableId, _isOpen]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, 0] call FUNC(applyGamePowerLoad)};

if (([_table, _deviceNetId] call FUNC(seatOf)) < 0) exitWith {[_device, 0] call FUNC(applyGamePowerLoad)};

private _openDevices = _table getOrDefault ["open", []];

if (_isOpen) then
{
    _openDevices pushBackUnique _deviceNetId;
}
else
{
    _openDevices = _openDevices - [_deviceNetId];
};

_table set ["open", _openDevices];
missionNamespace setVariable [QGVAR(tables), _tables];

private _setting = ["IdleDraw", "PowerDraw"] select _isOpen;

[_device, [_device, _setting] call FUNC(getSetting)] call FUNC(applyGamePowerLoad);

if (_isOpen) then
{
    [_tableId] call FUNC(pushState);
};
