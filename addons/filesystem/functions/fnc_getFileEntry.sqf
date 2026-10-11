// File: fnc_getFileEntry.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the raw filesystem entry ([content, owner, permissions, size?]) at a path
 * without a permission check on the entry itself. Throws if the path does not exist.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to the entry
 * 3: _user <STRING> (Optional, default: "") - User resolving the path
 *
 * Return Value:
 * Filesystem entry (by reference) <ARRAY>
 *
 * Example:
 * private _entry = [[], _filesystem, "/data/plans.bin", "root"] call AE3_filesystem_fnc_getFileEntry;
 *
 * Public: Yes
 */

params ["_pntr", "_filesystem", "_target", ["_user", ""]];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getParentDir;
private _current = (_dir select 1) select 0;
private _name = _dir select 2;

if (!(_name in _current)) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", _name]);

_current get _name
