// File: fnc_setSetting.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Writes a games setting, either on one device or as the mission-wide runtime override a
 * curator sets through the Games module. Clearing a value (nil) drops back to the next source in the
 * order AE3_games_fnc_getSetting resolves, so a curator can always hand control back to the mission
 * setting. Mission-wide writes are server authoritative and broadcast; a device write rides on the
 * object like every other AE3 device setting.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device to write on, objNull for the mission-wide override
 * 1: _setting <STRING> - Setting name without its prefix, e.g. "TurnTimeout"
 * 2: _value <ANY> (Optional) - Value to store, omitted or nil clears it
 *
 * Return Value:
 * None
 *
 * Example:
 * [objNull, "TurnTimeout", 120] call AE3_games_fnc_setSetting;
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_setting", "", [""]], "_value"];

if (_setting isEqualTo "") exitWith {};

if (!isNull _device) exitWith
{
    if (isNil "_value") then
    {
        _device setVariable [format [QGVAR(set_%1), _setting], nil, true];
    }
    else
    {
        _device setVariable [format [QGVAR(set_%1), _setting], _value, true];
    };

    // Availability is published as its own flag, so the app list follows the change
    if (_setting isEqualTo "Enabled" && {isServer}) then
    {
        [_device] call FUNC(refreshAvailability);
    };
};

if (!isServer) exitWith
{
    if (isNil "_value") then
    {
        ["ae3_games_setOverride", [_setting]] call CBA_fnc_serverEvent;
    }
    else
    {
        ["ae3_games_setOverride", [_setting, _value]] call CBA_fnc_serverEvent;
    };
};

private _overrides = missionNamespace getVariable [QGVAR(overrides), createHashMap];

if (isNil "_value") then
{
    _overrides deleteAt _setting;
}
else
{
    _overrides set [_setting, _value];
};

missionNamespace setVariable [QGVAR(overrides), _overrides, true];

// Availability is published per device, so a mission-wide change is pushed out to all of them
if (_setting isEqualTo "Enabled") then
{
    [objNull] call FUNC(refreshAvailability);
};
