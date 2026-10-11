// File: fnc_setFileSize.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sets or clears the virtual size of a filesystem entry. The size is stored as the
 * optional fourth element of the entry ([content, owner, permissions, size]) and travels with the
 * entry through copies, moves and network sync. Requires write permission on the entry.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to the entry
 * 3: _user <STRING> - User performing the change
 * 4: _size <NUMBER> - Size in bytes; negative clears the virtual size (real size is used again)
 *
 * Return Value:
 * None
 *
 * Example:
 * [[], _filesystem, "/data/plans.bin", "root", 50 * 1024 * 1024] call AE3_filesystem_fnc_setFileSize;
 *
 * Public: Yes
 */

params ["_pntr", "_filesystem", "_target", "_user", "_size"];

private _entry = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_getFileEntry;

[_entry, _user, 1] call AE3_filesystem_fnc_hasPermission;

if (_size < 0) then
{
	_entry resize 3;
}
else
{
	_entry set [3, round _size];
};
