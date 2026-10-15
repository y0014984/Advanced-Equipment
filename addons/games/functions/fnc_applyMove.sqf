// File: fnc_applyMove.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Validates and applies one move. Every rule lives here and in the game's rules
 * function, on the server, so a client cannot move for an opponent, move out of turn, reroll a die or
 * learn what another seat is holding. A refused move changes nothing and tells only the player who
 * tried it. Runs on the server; a client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the device the move came from
 * 1: _tableId <STRING> - Table id
 * 2: _move <STRING> - Move in the game's own notation, e.g. "e2e4"
 * 3: _owner <NUMBER> (Optional) - Machine network id the request came from
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3", "e2e4", clientOwner] call AE3_games_fnc_applyMove;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]], ["_move", "", [""]], ["_owner", 0, [0]]];

if (!isServer) exitWith {["ae3_games_move", [_deviceNetId, _tableId, _move, clientOwner]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, "$STR_AE3_Games_Status_NoSuchTable"] call FUNC(pushNotice)};

private _seat = [_table, _deviceNetId] call FUNC(seatOf);

if (_seat < 0) exitWith {[_device, "$STR_AE3_Games_Status_NotSeated"] call FUNC(pushNotice)};

// The move has to come from the machine that is actually driving this device, and the device has to
// be powered on and in someone's hands - a laptop nobody is sitting at does not make moves
private _operator = [_device] call FUNC(operatorOwner);

if (_operator <= 0) exitWith {[_device, "$STR_AE3_Games_Status_NotInUse"] call FUNC(pushNotice)};
if (_owner > 0 && (_operator != _owner)) exitWith {[_device, "$STR_AE3_Games_Status_NotInUse"] call FUNC(pushNotice)};

if ((_device getVariable ["AE3_power_powerState", 0]) != 1) exitWith {[_device, "$STR_AE3_Games_Status_NoPower"] call FUNC(pushNotice)};

// The host device is the table, so losing the route to it ends participation until it is back
private _host = objectFromNetId (_table getOrDefault ["host", ""]);

if (_device isNotEqualTo _host && {!([_device, _host] call FUNC(reachable))}) exitWith
{
    [_device, "$STR_AE3_Games_Status_Unreachable"] call FUNC(pushNotice);
};

if ((_table getOrDefault ["phase", "lobby"]) isNotEqualTo "play") exitWith
{
    [_device, "$STR_AE3_Games_Status_NotStarted"] call FUNC(pushNotice);
};

private _info = [_table getOrDefault ["gameId", ""]] call FUNC(gameInfo);

if (_info isEqualTo []) exitWith {};

_info params ["_rules"];

private _state = _table getOrDefault ["state", []];
private _turn = ["turn", _state] call _rules;

// A turn of -1 means the game takes moves from any seat at once, as rock paper scissors does
if (_turn >= 0 && (_turn != _seat)) exitWith {[_device, "$STR_AE3_Games_Status_NotYourTurn"] call FUNC(pushNotice)};

(["apply", _state, _seat, _move] call _rules) params [["_ok", false], ["_newState", []], ["_reasonKey", "$STR_AE3_Games_Status_IllegalMove"]];

if (!_ok) exitWith {[_device, _reasonKey] call FUNC(pushNotice)};

private _winner = ["winner", _newState] call _rules;

_table set ["state", _newState];
_table set ["turn", ["turn", _newState] call _rules];
_table set ["winner", _winner];
_table set ["lastMoveAt", serverTime];
_table set ["status", _reasonKey];

// -1 means the game is still running, a seat index means that seat won, -2 means a draw
if (_winner != -1) then
{
    _table set ["phase", "over"];
};

missionNamespace setVariable [QGVAR(tables), _tables];

[_tableId] call FUNC(pushState);
