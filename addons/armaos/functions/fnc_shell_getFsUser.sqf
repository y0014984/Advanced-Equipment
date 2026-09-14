// File: fnc_shell_getFsUser.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Resolves the account name a terminal command should hand to the filesystem permission
 * layer. That is normally the logged-in user, so file ownership still means something at the shell. A
 * superuser is the exception: root, admin, and every /etc/sudoers member resolve to "root", which the
 * permission check treats as unrestricted. The desktop file manager has always elevated superusers this
 * way; doing the same at the terminal keeps one account from having two different sets of rights
 * depending on which interface it is used from. Missions that want strict Unix semantics - where a
 * sudoer must type sudo or su before reaching another user's files - turn the AE3_CliElevateSudoers
 * setting off, and every command falls back to the login user.
 * The real identity is untouched: whoami, sudo, su and the login prompt all keep reading
 * AE3_terminalLoginUser directly, so an elevated sudoer is still shown and logged as themselves.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer whose terminal session is running the command
 *
 * Return Value:
 * Account name to pass into the filesystem permission checks <STRING>
 *
 * Example:
 * private _username = [_computer] call AE3_armaos_fnc_shell_getFsUser;
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith { "" };

private _terminal = _computer getVariable ["AE3_terminal", createHashMap];
private _username = _terminal getOrDefault ["AE3_terminalLoginUser", ""];

if (_username isEqualTo "") exitWith { "" };
if (_username isEqualTo "root" || _username isEqualTo "admin") exitWith { "root" };
if (!(missionNamespace getVariable ["AE3_CliElevateSudoers", true])) exitWith { _username };

if ([_computer, _username] call AE3_armaos_fnc_computer_isSudoer) exitWith { "root" };

_username
