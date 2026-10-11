// File: fnc_parseSize.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Converts a size given as a number of bytes or as text with a unit (B, KB, MB, GB;
 * base 1024; single-letter K/M/G accepted) into bytes. Empty text or a negative value yields -1,
 * meaning "no virtual size".
 *
 * Arguments:
 * 0: _value <NUMBER|STRING> - Size to parse
 *
 * Return Value:
 * Size in bytes, or -1 <NUMBER>
 *
 * Example:
 * ["1.5GB"] call AE3_filesystem_fnc_parseSize; // 1610612736
 * [4096] call AE3_filesystem_fnc_parseSize;    // 4096
 *
 * Public: Yes
 */

params [["_value", -1, [0, ""]]];

if (_value isEqualType 0) exitWith { [-1, round _value] select (_value >= 0) };

private _text = toUpper ((trim _value) regexReplace [" ", ""]);
if (_text isEqualTo "") exitWith { -1 };

private _multiplier = 1;
{
	_x params ["_suffix", "_factor"];
	private _len = count _suffix;
	if ((count _text) > _len && {(_text select [(count _text) - _len]) isEqualTo _suffix}) exitWith
	{
		_multiplier = _factor;
		_text = _text select [0, (count _text) - _len];
	};
} forEach [["GB", 1073741824], ["MB", 1048576], ["KB", 1024], ["G", 1073741824], ["M", 1048576], ["K", 1024], ["B", 1]];

private _number = parseNumber _text;
if (_number < 0) exitWith { -1 };

round (_number * _multiplier)
