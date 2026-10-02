// File: fnc_computer_addSudoer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Grants a user superuser rights on a computer by adding the account to /etc/sudoers.
 * Initialises the device on demand, creates /etc and /etc/sudoers when missing, ignores duplicates and
 * broadcasts the filesystem, so it can be called from mission scripts at any point without waiting for
 * the laptop's own init. Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to modify
 * 1: _username <STRING> - The account that gets superuser rights
 *
 * Return Value:
 * true if the account is listed in /etc/sudoers afterwards <BOOL>
 *
 * Example:
 * [_laptop, "cracked"] call AE3_armaos_fnc_computer_addSudoer;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_username", "", [""]]];

if (!isServer) exitWith { false };
if (isNull _computer) exitWith { false };

_username = trim _username;
if (_username isEqualTo "" || _username isEqualTo "root") exitWith { false };

if (!([_computer] call AE3_armaos_fnc_device_ensureInit)) exitWith
{
	WARNING_1("addSudoer: %1 is not an initialized AE3 device",typeOf _computer);
	false
};

private _filesystem = _computer getVariable ["AE3_filesystem", []];
if (_filesystem isEqualTo []) exitWith { false };

private _success = true;

try
{
	[[], _filesystem, "/etc", "root", "root"] call AE3_filesystem_fnc_ensureDir;
	[[], _filesystem, "/etc/sudoers", "", "root", "root", [[true, true, false], [false, false, false]]] call AE3_filesystem_fnc_ensureFile;

	private _sudoers = [_computer] call AE3_armaos_fnc_computer_getSudoers;

	_sudoers pushBackUnique _username;

	[[], _filesystem, "/etc/sudoers", "root", (_sudoers joinString endl) + endl] call AE3_filesystem_fnc_writeToFile;

	// Broadcast roster kept alongside the file: permission checks run on clients, whose filesystem
	// copy can be stale or still syncing, and a missed sudoer there reads as a permission failure.
	_computer setVariable ["AE3_sudoers", _sudoers, true];
}
catch
{
	WARNING_2("addSudoer: failed to add '%1': %2",_username,_exception);
	_success = false;
};

if (!_success) exitWith { false };

_computer setVariable ["AE3_filesystem", _filesystem, true];

["ae3_computer_sudoerAdded", [_computer, _username]] call CBA_fnc_globalEvent;

true
