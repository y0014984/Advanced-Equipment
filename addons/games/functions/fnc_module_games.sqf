// File: fnc_module_games.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: The Games module, for Eden and for Zeus. In Eden it is where the games settings are
 * set: each one it carries is written onto every computer synced to the module, or as the mission-wide
 * value when nothing is synced to it, and a setting left on Mission setting is left where it is. A
 * curator dropping the module gets the roster dialog instead, which is the same settings for the
 * session plus the live tables, so the module reads one way in the editor and another in Zeus.
 *
 * Arguments:
 * 0: _module <OBJECT> - Module logic
 * 1: _syncedUnits <ARRAY> - Synced computers
 * 2: _activated <BOOL> - Module activation state
 *
 * Return Value:
 * None
 *
 * Example:
 * [_module, [_laptop], true] call AE3_games_fnc_module_games;
 *
 * Public: No
 */

params [["_module", objNull, [objNull]], ["_syncedUnits", [], [[]]], ["_activated", true, [true]]];

if (isNull _module || !_activated) exitWith {};

// A curator is after the roster, not the attributes: the module they drop carries whatever the
// mission maker left on it, which is nothing they chose
if (_module getVariable ["BIS_fnc_moduleInit_isCuratorPlaced", false]) exitWith {_this call FUNC(zeus_games)};

if (!isServer) exitWith {};

// Property name on the module, paired with the setting it writes and how the box is read back. The
// combos answer "default", "yes" or "no"; the edit boxes answer a number as text, blank for untouched.
private _settings =
[
    ["AE3_Module_Games_Enabled", "Enabled", "bool"],
    ["AE3_Module_Games_AllowHosting", "AllowHosting", "bool"],
    ["AE3_Module_Games_GraphicalUI", "GraphicalUI", "bool"],
    ["AE3_Module_Games_DebugSeats", "DebugSeats", "bool"],
    ["AE3_Module_Games_PowerDraw", "PowerDraw", "number"]
];

// With nothing synced the module speaks for the whole mission, which is the only way to reach the
// settings a single computer has no say over anyway
private _targets = _syncedUnits select {isClass (configOf _x >> "AE3_Device")};

if (_targets isEqualTo []) then {_targets = [objNull]};

{
    _x params ["_property", "_setting", "_kind"];

    private _answer = _module getVariable [_property, "default"];
    private _value = nil;

    if (_kind isEqualTo "bool") then
    {
        if (_answer in ["yes", "no"]) then {_value = _answer isEqualTo "yes"};
    }
    else
    {
        if ((_answer splitString " " joinString "") isNotEqualTo "") then {_value = parseNumber _answer};
    };

    // Mission setting: nothing is written, so whatever decides that setting today keeps deciding it
    if (!isNil "_value") then
    {
        {
            [_x, _setting, _value] call FUNC(setSetting);
        } forEach _targets;
    };
} forEach _settings;

deleteVehicle _module;
