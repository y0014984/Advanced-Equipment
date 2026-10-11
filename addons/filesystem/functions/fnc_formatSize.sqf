// File: fnc_formatSize.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Formats a byte count for display (B, KB, MB, GB; base 1024, one decimal).
 *
 * Arguments:
 * 0: _bytes <NUMBER> - Size in bytes
 *
 * Return Value:
 * Human readable size <STRING>
 *
 * Example:
 * [1572864] call AE3_filesystem_fnc_formatSize; // "1.5 MB"
 *
 * Public: Yes
 */

params [["_bytes", 0, [0]]];

if (_bytes < 1024) exitWith { format ["%1 B", round _bytes] };

private _value = _bytes;
private _unit = "B";
{
	if (_value < 1024) exitWith {};
	_value = _value / 1024;
	_unit = _x;
} forEach ["KB", "MB", "GB", "TB"];

format ["%1 %2", _value toFixed 1, _unit]
