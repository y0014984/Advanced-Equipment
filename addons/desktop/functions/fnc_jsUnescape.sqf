// File: fnc_jsUnescape.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Decodes the \uXXXX escapes at or above code point 128 in a JSON string sent by the
 * web desktop, joining surrogate pairs. Escaped backslashes are kept as they are, so a literal
 * "A" in user text survives. Lower escapes are left for the JSON parser.
 *
 * Arguments:
 * 0: _message <STRING> - JSON text
 *
 * Return Value:
 * JSON text with non-ASCII characters restored <STRING>
 *
 * Example:
 * [_message] call AE3_desktop_fnc_jsUnescape;
 *
 * Public: No
 */

params [["_message", "", [""]]];

if ((_message find "\u") < 0) exitWith { _message };

private _codes = toArray _message;
private _count = count _codes;

// Value of the 4 hex digits starting at _start, or -1.
private _hexAt = {
	params ["_start"];
	if (_start + 4 > _count) exitWith { -1 };
	private _value = 0;
	{
		private _digit = switch (true) do
		{
			case (_x >= 48 && _x <= 57): { _x - 48 };
			case (_x >= 97 && _x <= 102): { _x - 87 };
			case (_x >= 65 && _x <= 70): { _x - 55 };
			default { -1 };
		};
		if (_digit < 0) exitWith { _value = -1; };
		_value = _value * 16 + _digit;
	} forEach (_codes select [_start, 4]);
	_value
};

private _out = [];
private _i = 0;
while { _i < _count } do
{
	private _c = _codes select _i;
	if (_c != 92 || {_i + 1 >= _count}) then
	{
		_out pushBack _c;
		_i = _i + 1;
	}
	else
	{
		private _next = _codes select (_i + 1);
		private _value = if (_next == 117) then { [_i + 2] call _hexAt } else { -1 };
		if (_value < 128) then
		{
			_out append [_c, _next];
			_i = _i + 2;
		}
		else
		{
			_i = _i + 6;
			if (_value >= 55296 && _value <= 56319 && {_i + 5 < _count} && {(_codes select _i) == 92} && {(_codes select (_i + 1)) == 117}) then
			{
				private _low = [_i + 2] call _hexAt;
				if (_low >= 56320 && _low <= 57343) then
				{
					_value = 65536 + (_value - 55296) * 1024 + (_low - 56320);
					_i = _i + 6;
				};
			};
			_out pushBack _value;
		};
	};
};

toString _out
