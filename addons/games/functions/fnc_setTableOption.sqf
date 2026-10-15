// File: fnc_setTableOption.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Answers one of the questions a table asks: what the table is called, what the player
 * at a seat is called, which side a seat would like to play and which seat moves first. All of them
 * are settled here on the server so a client cannot give itself white after the board has been
 * built. The first three questions belong to the lobby; a seat name is the seat's own business and
 * can be changed at any point in a match, since nothing is decided by it. Runs on the server; a
 * client call is routed there.
 *
 * Arguments:
 * 0: _deviceNetId <STRING> - Network id of the device asking
 * 1: _tableId <STRING> - Table id
 * 2: _option <STRING> - "name", "seatname", "pref" or "starter"
 * 3: _value <STRING> - Table name, the seat's name, "white"/"black"/"random", or the seat number
 *    for a starter
 *
 * Return Value:
 * None
 *
 * Example:
 * [netId _computer, "chess-3", "pref", "white"] call AE3_games_fnc_setTableOption;
 *
 * Public: Yes
 */

params [["_deviceNetId", "", [""]], ["_tableId", "", [""]], ["_option", "", [""]], ["_value", "", [""]]];

if (!isServer) exitWith {["ae3_games_option", [_deviceNetId, _tableId, _option, _value]] call CBA_fnc_serverEvent};

private _device = objectFromNetId _deviceNetId;

if (isNull _device) exitWith {};

private _tables = missionNamespace getVariable [QGVAR(tables), createHashMap];
private _table = _tables get _tableId;

if (isNil "_table") exitWith {[_device, "$STR_AE3_Games_Status_NoSuchTable"] call FUNC(pushNotice)};

private _seat = [_table, _deviceNetId] call FUNC(seatOf);

if (_seat < 0) exitWith {[_device, "$STR_AE3_Games_Status_NotSeated"] call FUNC(pushNotice)};

private _isHost = (_table getOrDefault ["host", ""]) isEqualTo _deviceNetId;

// Naming your own seat decides nothing about the match, so it is the one answer a started table
// still takes; everything else would be rewriting a board that has already been built
if ((_table getOrDefault ["phase", "lobby"]) isNotEqualTo "lobby" && {(toLowerANSI _option) isNotEqualTo "seatname"}) exitWith
{
    [_device, "$STR_AE3_Games_Status_AlreadyStarted"] call FUNC(pushNotice);
};

switch (toLowerANSI _option) do
{
    case "name":
    {
        if (!_isHost) exitWith {[_device, "$STR_AE3_Games_Status_HostOnly"] call FUNC(pushNotice)};

        _table set ["name", _value select [0, 40]];
    };

    case "seatname":
    {
        // The label rides on the seat, so it follows that seat through a renumber at the start of a
        // match and is what both front ends already print. An empty name hands the seat back to the
        // computer's own name.
        private _seats = _table getOrDefault ["seats", []];
        private _row = _seats findIf {(_x select 1) isEqualTo _seat};

        if (_row < 0) exitWith {[_device, "$STR_AE3_Games_Status_NotSeated"] call FUNC(pushNotice)};

        private _wanted = _value select [0, 24];

        if ((_wanted splitString " " joinString "") isEqualTo "") then {_wanted = ""};

        (_seats select _row) set [2, _wanted];
        _table set ["seats", _seats];
    };

    case "pref":
    {
        private _wanted = toLowerANSI _value;

        if !(_wanted in ["white", "black", "random"]) exitWith
        {
            [_device, "$STR_AE3_Games_Status_BadSide"] call FUNC(pushNotice);
        };

        // Keyed by seat rather than by device, so a host driving two practice seats answers for each
        private _prefs = _table getOrDefault ["prefs", createHashMap];

        _prefs set [str _seat, _wanted];
        _table set ["prefs", _prefs];
    };

    case "starter":
    {
        if (!_isHost) exitWith {[_device, "$STR_AE3_Games_Status_HostOnly"] call FUNC(pushNotice)};

        private _wanted = round (parseNumber _value);

        if (((_table getOrDefault ["seats", []]) findIf {(_x select 1) isEqualTo _wanted}) < 0) exitWith
        {
            [_device, "$STR_AE3_Games_Status_NotSeated"] call FUNC(pushNotice);
        };

        _table set ["starter", _wanted];
    };

    default {};
};

missionNamespace setVariable [QGVAR(tables), _tables];

[_tableId] call FUNC(pushState);
