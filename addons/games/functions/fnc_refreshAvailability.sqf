// File: fnc_refreshAvailability.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Publishes whether games are available on a device, as one broadcast flag the web
 * desktop filters its app list against, so a computer a mission maker or curator excluded simply has
 * no games on it rather than offering an app that refuses to work. The flag is the resolved setting,
 * so it already accounts for the device's own value, a curator's runtime override and the mission
 * setting. Called when a device initialises, when its own setting is written and when the mission
 * setting changes. Server only.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device to refresh, objNull to refresh every known computer
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_games_fnc_refreshAvailability;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]]];

if (!isServer) exitWith {};

if (isNull _device) exitWith
{
    {
        [_x] call FUNC(refreshAvailability);
    } forEach (missionNamespace getVariable ["ae3_desktop_computers", []]);
};

private _enabled = [_device, "Enabled"] call FUNC(getSetting);

_device setVariable [QGVAR(enabled), _enabled isEqualTo true, true];
