// File: fnc_deviceLabel.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Short name for a device as it appears in a lobby or seat list. Prefers the hostname a
 * mission maker gave the computer, falls back to its display name, so a seat list reads like the
 * network does rather than showing class names.
 *
 * Arguments:
 * 0: _device <OBJECT> - Device
 *
 * Return Value:
 * Label <STRING>
 *
 * Example:
 * private _label = [_computer] call AE3_games_fnc_deviceLabel;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]]];

if (isNull _device) exitWith {"unknown"};

private _hostname = _device getVariable ["ace_cargo_customName", ""];

if (_hostname isNotEqualTo "") exitWith {_hostname};

private _displayName = getText (configOf _device >> "displayName");

if (_displayName isNotEqualTo "") exitWith {_displayName};

typeOf _device
