// File: fnc_computer_removeSudoer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Revokes a user's superuser rights on a computer by removing the account from
 * /etc/sudoers. Rewrites the file with the remaining accounts and broadcasts the filesystem. A user
 * that is not listed is a no-op. Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to modify
 * 1: _username <STRING> - The account that loses superuser rights
 *
 * Return Value:
 * true if the account is no longer listed in /etc/sudoers <BOOL>
 *
 * Example:
 * [_laptop, "cracked"] call AE3_armaos_fnc_computer_removeSudoer;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_username", "", [""]]];

if (!isServer) exitWith { false };
if (isNull _computer) exitWith { false };

_username = trim _username;
if (_username isEqualTo "") exitWith { false };

private _filesystem = _computer getVariable ["AE3_filesystem", []];
if (_filesystem isEqualTo []) exitWith { false };

private _sudoers = [_computer] call AE3_armaos_fnc_computer_getSudoers;

// Matched the same way superuser rights are checked: case-insensitively and without surrounding
// whitespace, so an account cannot keep its rights through a difference in spelling.
private _key = toLowerANSI _username;
private _remaining = _sudoers select { toLowerANSI (trim _x) isNotEqualTo _key };
if (_remaining isEqualTo _sudoers) exitWith { true };

_sudoers = _remaining;

private _success = true;

try
{
	private _content = "";
	if (_sudoers isNotEqualTo []) then { _content = (_sudoers joinString endl) + endl; };

	[[], _filesystem, "/etc/sudoers", "root", _content] call AE3_filesystem_fnc_writeToFile;

	// Keep the broadcast roster in step with the file; permission checks read it on clients.
	_computer setVariable ["AE3_sudoers", _sudoers, true];
}
catch
{
	WARNING_2("removeSudoer: failed to remove '%1': %2",_username,_exception);
	_success = false;
};

if (!_success) exitWith { false };

_computer setVariable ["AE3_filesystem", _filesystem, true];

["ae3_computer_sudoerRemoved", [_computer, _username]] call CBA_fnc_globalEvent;

true
