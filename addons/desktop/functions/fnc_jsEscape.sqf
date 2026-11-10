// File: fnc_jsEscape.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Replaces every character above code point 127 in a JSON string with a \uXXXX escape
 * (a surrogate pair above 0xFFFF), so the string passed to ExecJS is plain ASCII.
 *
 * Arguments:
 * 0: _json <STRING> - JSON text
 *
 * Return Value:
 * ASCII-only JSON text <STRING>
 *
 * Example:
 * [_json] call AE3_desktop_fnc_jsEscape;
 *
 * Public: No
 */

params [["_json", "", [""]]];

private _codes = toArray _json;
if ((_codes findIf { _x > 127 }) < 0) exitWith { _json };

private _digits = toArray "0123456789abcdef";
private _escape = {
	params ["_unit"];
	[92, 117] + ([4096, 256, 16, 1] apply { _digits select ((floor (_unit / _x)) mod 16) })
};

private _out = [];
{
	if (_x < 128) then
	{
		_out pushBack _x;
	}
	else
	{
		if (_x > 65535) then
		{
			private _v = _x - 65536;
			_out append ([55296 + floor (_v / 1024)] call _escape);
			_out append ([56320 + (_v mod 1024)] call _escape);
		}
		else
		{
			_out append ([_x] call _escape);
		};
	};
} forEach _codes;

toString _out
