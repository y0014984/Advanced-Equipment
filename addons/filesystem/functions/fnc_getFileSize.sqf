// File: fnc_getFileSize.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the effective size of a filesystem entry in bytes. A virtual size (fourth
 * entry element) wins; otherwise text content counts its characters and other content its string
 * form. Directories return the sum of their children.
 *
 * Arguments:
 * 0: _entry <ARRAY> - Filesystem entry [content, owner, permissions, size?]
 *
 * Return Value:
 * Size in bytes <NUMBER>
 *
 * Example:
 * private _bytes = [_entry] call AE3_filesystem_fnc_getFileSize;
 *
 * Public: Yes
 */

params [["_entry", [], [[]]]];

if (_entry isEqualTo []) exitWith { 0 };

private _content = _entry select 0;

if (_content isEqualType createHashMap) exitWith
{
	private _total = 0;
	{
		_total = _total + ([_y] call AE3_filesystem_fnc_getFileSize);
	} forEach _content;
	_total
};

private _virtual = _entry param [3, -1, [0]];
if (_virtual >= 0) exitWith { _virtual };

[count (str _content), count _content] select (_content isEqualType "")
