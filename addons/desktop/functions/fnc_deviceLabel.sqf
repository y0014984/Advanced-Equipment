// File: fnc_deviceLabel.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns a human-readable label for an AE3 device (laptop) object. Laptops are not
 * units, so the SQF `name` command is invalid on them (it logs "Function 'name' ... has no unit").
 * This resolves a friendly name in the same order the rest of the addon uses: ACE custom cargo
 * name first, then the config display name. Safe on objNull.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device/laptop object
 *
 * Return Value:
 * Label <STRING>
 *
 * Example:
 * [_laptop] call AE3_desktop_fnc_deviceLabel;
 *
 * Public: No
 */

params [["_device", objNull, [objNull]]];

if (isNull _device) exitWith { "" };

[_device] call AE3_main_fnc_getDeviceName
