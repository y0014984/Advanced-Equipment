// File: fnc_computer_setRootPassword.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sets the root password of a single computer. The password is stored in AE3_rootPassword
 * and written into the computer's user list, so the terminal, the desktop login and ssh all accept it.
 * Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to configure
 * 1: _password <STRING> - The new root password
 *
 * Return Value:
 * true if the password was applied <BOOL>
 *
 * Example:
 * [_laptop, "hunter2"] call AE3_armaos_fnc_computer_setRootPassword;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_password", "", [""]]];

if (!isServer) exitWith { false };
if (isNull _computer || _password isEqualTo "") exitWith { false };

_computer setVariable ["AE3_rootPassword", _password, true];

private _userlist = _computer getVariable ["AE3_Userlist", createHashMap];
_userlist set ["root", _password];
_computer setVariable ["AE3_Userlist", _userlist, true];

true
