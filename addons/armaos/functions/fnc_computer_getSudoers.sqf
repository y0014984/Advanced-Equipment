// File: fnc_computer_getSudoers.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the accounts with superuser rights on a computer. The list is the union of the
 * broadcast AE3_sudoers roster and the accounts written in /etc/sudoers (one username per line).
 * Reading the file alone is not enough on a client, whose copy of the filesystem can be stale or
 * still syncing, which would silently drop a sudoer back to unprivileged; reading the roster alone
 * would miss a sudoers file edited directly by a mission script. Blank lines and surrounding
 * whitespace are ignored. root is not part of the list; it is always a superuser.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to read from
 *
 * Return Value:
 * Usernames with superuser rights <ARRAY of STRING>
 *
 * Example:
 * private _sudoers = [_laptop] call AE3_armaos_fnc_computer_getSudoers;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith { [] };

// The roster is broadcast whenever a sudoer is added or removed, so it is available even on a client
// whose filesystem copy has not caught up yet.
private _sudoers = +(_computer getVariable ["AE3_sudoers", []]);

private _filesystem = _computer getVariable ["AE3_filesystem", []];
if (_filesystem isEqualTo []) exitWith { _sudoers };

try
{
	// read as root: /etc/sudoers is deliberately unreadable for everyone else
	private _content = [[], _filesystem, "/etc/sudoers", "root", 0] call AE3_filesystem_fnc_getFile;

	if (_content isEqualType "") then
	{
		{
			private _name = trim _x;
			if (_name isNotEqualTo "" && {!(_name in _sudoers)}) then { _sudoers pushBack _name; };
		} forEach (_content splitString endl);
	};
}
catch
{
	// no sudoers file (or no /etc at all) leaves the broadcast roster as the only source
};

_sudoers
