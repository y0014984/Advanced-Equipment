// File: fnc_shell_tokenize.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Splits a shell input line into tokens. Supports double and single quoted
 * segments so paths and arguments may contain spaces: cd "my dir"  /  echo 'hello world'.
 * Unicode-safe (character based, not byte based).
 *
 * Arguments:
 * 0: _input <STRING> - Raw command line
 *
 * Return Value:
 * Tokens <ARRAY of STRING>
 *
 * Example:
 * private _tokens = ["cd ""my dir"""] call AE3_armaos_fnc_shell_tokenize; // ["cd", "my dir"]
 *
 * Public: Yes
 */

params [["_input", ""]];

if (_input isEqualTo "") exitWith { [] };

forceUnicode 1;

private _tokens = [];
private _buffer = "";
private _quote = "";
private _inToken = false;

{
	private _char = _x;

	switch (true) do
	{
		// closing quote
		case (_quote isNotEqualTo "" && _char isEqualTo _quote):
		{
			_quote = "";
		};
		// inside quotes - take everything literally
		case (_quote isNotEqualTo ""):
		{
			_buffer = _buffer + _char;
		};
		// opening quote
		case (_char isEqualTo """" || _char isEqualTo "'"):
		{
			_quote = _char;
			_inToken = true; // empty quoted string still yields a token
		};
		// token separator
		case (_char isEqualTo " "):
		{
			if (_inToken || _buffer isNotEqualTo "") then
			{
				_tokens pushBack _buffer;
				_buffer = "";
				_inToken = false;
			};
		};
		default
		{
			_buffer = _buffer + _char;
		};
	};
} forEach (_input splitString "");

if (_inToken || _buffer isNotEqualTo "") then
{
	_tokens pushBack _buffer;
};

forceUnicode -1;

_tokens
