// File: fnc_zeus_showRoster.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Shows a curator the live tables and the session settings and applies what they change.
 * With Zeus Enhanced loaded this is a dialog; without it the roster is printed to the curator's chat
 * and the settings are left to the CBA menu, because a curator-only read is still worth having when
 * no dialog framework is present. A number left empty keeps the mission setting. Client only.
 *
 * Arguments:
 * 0: _rows <ARRAY> - Table roster from the server
 * 1: _settings <ARRAY> - Mission-wide settings as [name, value] pairs
 *
 * Return Value:
 * None
 *
 * Example:
 * [_rows, _settings] call AE3_games_fnc_zeus_showRoster;
 *
 * Public: No
 */

params [["_rows", [], [[]]], ["_settings", [], [[]]]];

private _values = createHashMapFromArray _settings;

private _labels = ["$STR_AE3_Games_Zeus_NoTable"];
private _ids = [""];

{
    _x params ["_tableId", "_title", "_phase", "_seated", "_seatCount", "_players", "_idle"];

    _labels pushBack format ["%1 - %2, %3/%4 (%5) idle %6s", _title, _phase, _seated, _seatCount, _players, _idle];
    _ids pushBack _tableId;
} forEach _rows;

// No Zeus Enhanced: the roster is still readable, and the settings stay in the CBA menu
if (isNil "zen_dialog_fnc_create") exitWith
{
    {
        systemChat _x;
    } forEach (_labels select [1]);

    if (count _labels < 2) then {systemChat localize "STR_AE3_Games_Zeus_NoTables"};
};

[
    localize "STR_AE3_Games_Config_ModuleGamesDisplayName",
    [
        ["COMBO", [localize "STR_AE3_Games_Zeus_CloseTable", localize "STR_AE3_Games_Zeus_CloseTableTooltip"], [_ids, _labels, 0]],
        ["CHECKBOX", [localize "STR_AE3_Games_CbaSettings_EnabledName", localize "STR_AE3_Games_CbaSettings_EnabledTooltip"], _values getOrDefault ["Enabled", true]],
        ["CHECKBOX", [localize "STR_AE3_Games_CbaSettings_AllowHostingName", localize "STR_AE3_Games_CbaSettings_AllowHostingTooltip"], _values getOrDefault ["AllowHosting", true]],
        ["CHECKBOX", [localize "STR_AE3_Games_CbaSettings_RequireSameNetworkName", localize "STR_AE3_Games_CbaSettings_RequireSameNetworkTooltip"], _values getOrDefault ["RequireSameNetwork", true]],
        ["CHECKBOX", [localize "STR_AE3_Games_CbaSettings_GraphicalUIName", localize "STR_AE3_Games_CbaSettings_GraphicalUITooltip"], _values getOrDefault ["GraphicalUI", true]],
        ["CHECKBOX", [localize "STR_AE3_Games_CbaSettings_DebugSeatsName", localize "STR_AE3_Games_CbaSettings_DebugSeatsTooltip"], _values getOrDefault ["DebugSeats", false]],
        ["EDIT", [localize "STR_AE3_Games_CbaSettings_MaxTablesName", localize "STR_AE3_Games_Zeus_BlankKeepsSetting"], str (_values getOrDefault ["MaxTables", 16])],
        ["EDIT", [localize "STR_AE3_Games_CbaSettings_TurnTimeoutName", localize "STR_AE3_Games_Zeus_BlankKeepsSetting"], str (_values getOrDefault ["TurnTimeout", 0])],
        ["EDIT", [localize "STR_AE3_Games_CbaSettings_AbandonTimeoutName", localize "STR_AE3_Games_Zeus_BlankKeepsSetting"], str (_values getOrDefault ["AbandonTimeout", 3600])],
        ["EDIT", [localize "STR_AE3_Games_CbaSettings_PowerDrawName", localize "STR_AE3_Games_Zeus_BlankKeepsSetting"], str (_values getOrDefault ["PowerDraw", 0])],
        ["EDIT", [localize "STR_AE3_Games_CbaSettings_IdleDrawName", localize "STR_AE3_Games_Zeus_BlankKeepsSetting"], str (_values getOrDefault ["IdleDraw", 0])]
    ],
    {
        params ["_result"];

        _result params ["_closeId", "_enabled", "_allowHosting", "_requireNetwork", "_graphical", "_debugSeats", "_maxTables", "_turnTimeout", "_abandonTimeout", "_powerDraw", "_idleDraw"];

        [objNull, "Enabled", _enabled] call AE3_games_fnc_setSetting;
        [objNull, "AllowHosting", _allowHosting] call AE3_games_fnc_setSetting;
        [objNull, "RequireSameNetwork", _requireNetwork] call AE3_games_fnc_setSetting;
        [objNull, "GraphicalUI", _graphical] call AE3_games_fnc_setSetting;
        [objNull, "DebugSeats", _debugSeats] call AE3_games_fnc_setSetting;

        // An empty field means the mission setting keeps control of that value
        {
            _x params ["_name", "_text"];

            if ((_text splitString " " joinString "") isEqualTo "") then
            {
                [objNull, _name] call AE3_games_fnc_setSetting;
            }
            else
            {
                [objNull, _name, parseNumber _text] call AE3_games_fnc_setSetting;
            };
        } forEach
        [
            ["MaxTables", _maxTables],
            ["TurnTimeout", _turnTimeout],
            ["AbandonTimeout", _abandonTimeout],
            ["PowerDraw", _powerDraw],
            ["IdleDraw", _idleDraw]
        ];

        if (_closeId isNotEqualTo "") then
        {
            [_closeId, "$STR_AE3_Games_Status_Closed"] call AE3_games_fnc_closeTable;
        };
    },
    {},
    []
] call zen_dialog_fnc_create;
