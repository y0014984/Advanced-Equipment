// File: XEH_preInit.sqf
#include "script_component.hpp"
#include "XEH_PREP.hpp"

/* ================================================================================ */
/* Settings                                                                         */
/* ================================================================================ */

// Every one of these is only the policy default. A device can carry its own value as an object
// variable (Eden attribute or the Zeus asset panel) and a curator can override the mission-wide ones
// at runtime through the Games module; AE3_games_fnc_getSetting resolves that order.

[
    "AE3_Games_Enabled",
    "CHECKBOX",
    ["$STR_AE3_Games_CbaSettings_EnabledName", "$STR_AE3_Games_CbaSettings_EnabledTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    true,
    1, // 0 = per player, 1 = all clients share the server value, 2 = cannot be overwritten
    {
        // Devices carry the resolved value as a broadcast flag, so the desktop app list and the
        // terminal install follow a mid-mission change to the mission setting
        if (isServer) then {[objNull] call AE3_games_fnc_refreshAvailability};
    },
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_AllowHosting",
    "CHECKBOX",
    ["$STR_AE3_Games_CbaSettings_AllowHostingName", "$STR_AE3_Games_CbaSettings_AllowHostingTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    true,
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_RequireSameNetwork",
    "CHECKBOX",
    ["$STR_AE3_Games_CbaSettings_RequireSameNetworkName", "$STR_AE3_Games_CbaSettings_RequireSameNetworkTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    true,
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_MaxTables",
    "SLIDER",
    ["$STR_AE3_Games_CbaSettings_MaxTablesName", "$STR_AE3_Games_CbaSettings_MaxTablesTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    [1, 64, 16, 0],
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_TurnTimeout",
    "SLIDER",
    ["$STR_AE3_Games_CbaSettings_TurnTimeoutName", "$STR_AE3_Games_CbaSettings_TurnTimeoutTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    [0, 3600, 0, 0],
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_AbandonTimeout",
    "SLIDER",
    ["$STR_AE3_Games_CbaSettings_AbandonTimeoutName", "$STR_AE3_Games_CbaSettings_AbandonTimeoutTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    [0, 86400, 3600, 0],
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_PowerDraw",
    "SLIDER",
    ["$STR_AE3_Games_CbaSettings_PowerDrawName", "$STR_AE3_Games_CbaSettings_PowerDrawTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    [0, 0.05, 0.002, 4],
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_IdleDraw",
    "SLIDER",
    ["$STR_AE3_Games_CbaSettings_IdleDrawName", "$STR_AE3_Games_CbaSettings_IdleDrawTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    [0, 0.05, 0, 4],
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_GraphicalUI",
    "CHECKBOX",
    ["$STR_AE3_Games_CbaSettings_GraphicalUIName", "$STR_AE3_Games_CbaSettings_GraphicalUITooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    true,
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ==== */

[
    "AE3_Games_DebugSeats",
    "CHECKBOX",
    ["$STR_AE3_Games_CbaSettings_DebugSeatsName", "$STR_AE3_Games_CbaSettings_DebugSeatsTooltip"],
    "$STR_AE3_Games_CbaSettings_CategoryName",
    false,
    1,
    {},
    false
] call CBA_fnc_addSetting;

/* ================================================================================ */
/* Server events                                                                    */
/* ================================================================================ */

// Clients never hold authority over a match: they ask, the server decides and answers. Payloads are
// netId strings, numbers and plain strings only, because a HashMap does not survive a CBA event on a
// dedicated server.

if (isServer) then
{
    missionNamespace setVariable [QGVAR(tables), createHashMap];

    ["ae3_games_host", {_this call AE3_games_fnc_hostTable}] call CBA_fnc_addEventHandler;
    ["ae3_games_join", {_this call AE3_games_fnc_joinTable}] call CBA_fnc_addEventHandler;
    ["ae3_games_start", {_this call AE3_games_fnc_startTable}] call CBA_fnc_addEventHandler;
    ["ae3_games_leave", {_this call AE3_games_fnc_leaveTable}] call CBA_fnc_addEventHandler;
    ["ae3_games_close", {_this call AE3_games_fnc_closeTable}] call CBA_fnc_addEventHandler;
    ["ae3_games_move", {_this call AE3_games_fnc_applyMove}] call CBA_fnc_addEventHandler;
    ["ae3_games_list", {_this call AE3_games_fnc_getTables}] call CBA_fnc_addEventHandler;
    ["ae3_games_open", {_this call AE3_games_fnc_setGameOpen}] call CBA_fnc_addEventHandler;
    ["ae3_games_option", {_this call AE3_games_fnc_setTableOption}] call CBA_fnc_addEventHandler;
    ["ae3_games_seat", {_this call AE3_games_fnc_setActiveSeat}] call CBA_fnc_addEventHandler;
    ["ae3_games_dummy", {_this call AE3_games_fnc_addDummySeat}] call CBA_fnc_addEventHandler;

    ["ae3_games_install", {_this call AE3_games_fnc_installGames}] call CBA_fnc_addEventHandler;
    ["ae3_games_remove", {_this call AE3_games_fnc_removeGames}] call CBA_fnc_addEventHandler;
    ["ae3_games_roster", {_this call AE3_games_fnc_getRoster}] call CBA_fnc_addEventHandler;

    // Every AE3 device publishes whether games are available on it, which is what the desktop app
    // list is filtered against. Only devices that declare an AE3_Device config class qualify.
    ["All", "InitPost", {
        params ["_entity"];

        if (isClass (configOf _entity >> "AE3_Device")) then
        {
            [_entity] call AE3_games_fnc_refreshAvailability;
        };
    }] call CBA_fnc_addClassEventHandler;

    // Every computer carries every game from the moment it has finished starting up, and a computer
    // with games switched off carries none of them, whatever it was built with. Which of them it keeps
    // is the Add Games module's business, and that runs later, so there is nothing to ask here. The
    // event is the right hook rather than InitPost: it fires once the terminal and the virtual
    // filesystem both exist, and only for a device that actually has them.
    ["ae3_armaos_deviceReady", {
        params ["_device"];

        private _games = call AE3_games_fnc_gameIds;

        if ([_device, "Enabled"] call AE3_games_fnc_getSetting) then
        {
            [_device, _games] call AE3_games_fnc_installGames;
        }
        else
        {
            [_device, _games] call AE3_games_fnc_removeGames;
        };
    }] call CBA_fnc_addEventHandler;

    ["ae3_games_setOverride", {
        params [["_setting", "", [""]], "_value"];

        if (isNil "_value") then
        {
            [objNull, _setting] call AE3_games_fnc_setSetting;
        }
        else
        {
            [objNull, _setting, _value] call AE3_games_fnc_setSetting;
        };
    }] call CBA_fnc_addEventHandler;
};
