// File: fnc_shell_parseRedirect.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Splits an output redirection off a command line. Recognises "> FILE" (overwrite) and
 * ">> FILE" (append) outside of quotes, with or without a space before the file name; the last
 * redirection on the line wins. Quoted file names may contain spaces. A redirection without a file
 * name is reported as an empty target.
 *
 * Arguments:
 * 0: _commandString <STRING> - Raw command line
 *
 * Return Value:
 * [command without the redirection, target path ("" = no redirection), append mode, has redirection] <ARRAY>
 *
 * Example:
 * ["echo ""Hi"" >> notes.txt"] call AE3_armaos_fnc_shell_parseRedirect; // ["echo ""Hi"" ", "notes.txt", true, true]
 *
 * Public: Yes
 */

params [["_commandString", "", [""]]];

forceUnicode 1;

private _chars = _commandString splitString "";
private _quote = "";
private _position = -1;
private _append = false;

{
	switch (true) do
	{
		case (_quote isNotEqualTo "" && _x isEqualTo _quote): { _quote = ""; };
		case (_quote isNotEqualTo ""): {};
		case (_x isEqualTo """" || _x isEqualTo "'"): { _quote = _x; };
		case (_x isEqualTo ">"):
		{
			// The second '>' of a '>>' pair belongs to the redirection found one character earlier.
			if (_position == _forEachIndex - 1 && !_append) then
			{
				_append = true;
			}
			else
			{
				_position = _forEachIndex;
				_append = false;
			};
		};
	};
} forEach _chars;

if (_position == -1) exitWith
{
	forceUnicode -1;
	[_commandString, "", false, false]
};

private _command = (_chars select [0, _position]) joinString "";
private _rest = (_chars select [_position + ([1, 2] select _append)]) joinString "";

forceUnicode -1;

private _target = ([_rest] call AE3_armaos_fnc_shell_tokenize) param [0, ""];

[_command, _target, _append, true]
