// File: fnc_getSetting.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Reads a games setting for a device, resolving the three places one can be set in a
 * fixed order: the device's own object variable (Eden attribute or Zeus asset panel) first, then the
 * mission-wide runtime override a curator can set through the Games module, then the CBA setting.
 * Nothing else resolves that order, so no caller has to know it.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device the setting is read for, objNull for a mission-wide read
 * 1: _setting <STRING> - Setting name without its prefix, e.g. "TurnTimeout"
 *
 * Return Value:
 * Setting value, of whatever type the setting holds <ANY>
 *
 * Example:
 * private _timeout = [_computer, "TurnTimeout"] call AE3_games_fnc_getSetting;
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_setting", "", [""]]];

if (_setting isEqualTo "") exitWith {0};

private _value = 0;
private _found = false;

// Per-device value, written by the Eden attribute or the Zeus asset panel
if (!isNull _device) then
{
    private _deviceValue = _device getVariable format [QGVAR(set_%1), _setting];

    if (!isNil "_deviceValue") then
    {
        _value = _deviceValue;
        _found = true;
    };
};

// Mission-wide runtime override, written by a curator through the Games module
if (!_found) then
{
    private _override = (missionNamespace getVariable [QGVAR(overrides), createHashMap]) get _setting;

    if (!isNil "_override") then
    {
        _value = _override;
        _found = true;
    };
};

if (!_found) then
{
    _value = missionNamespace getVariable [format ["AE3_Games_%1", _setting], 0];
};

_value
