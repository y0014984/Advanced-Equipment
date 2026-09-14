// File: fnc_computer_isSudoer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Checks whether a user may act with superuser rights on a computer. True for root and
 * for every account listed in /etc/sudoers. Shared by the sudo command and the desktop file/volume
 * handlers so the terminal and the GUI grant the same rights.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to check
 * 1: _user <STRING> - The user to check
 *
 * Return Value:
 * true if the user has superuser rights on this computer <BOOL>
 *
 * Example:
 * private _elevated = [_laptop, "cracked"] call AE3_armaos_fnc_computer_isSudoer;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_user", "", [""]]];

_user = toLowerANSI (trim _user);

if (_user isEqualTo "root") exitWith { true };
if (isNull _computer || _user isEqualTo "") exitWith { false };

// Account names are compared case-insensitively and without surrounding whitespace, so a name typed
// at a login prompt matches the same name written into /etc/sudoers by a module or mission script.
private _sudoers = ([_computer] call AE3_armaos_fnc_computer_getSudoers) apply { toLowerANSI (trim _x) };

_user in _sudoers
