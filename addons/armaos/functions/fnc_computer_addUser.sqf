/*
 * Author: Root
 * Description: Adds a user account to a given computer by providing username and password. Creates a user directory at /home/<username>. Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to add the user to
 * 1: _username <STRING> - The username for the new account
 * 2: _password <STRING> - The password for the new account
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, "admin", "admin123"] call AE3_armaos_fnc_computer_addUser;
 *
 * Public: Yes
 */

params ["_computer", "_username", "_password"];

if (!isServer) exitWith {};

// Get userlist and filesystem from computer
private _userlist = _computer getVariable ["AE3_Userlist", createHashMap];
private _filesystem = _computer getVariable ["AE3_filesystem", []];

// Add user to userlist
_userlist set [_username, _password];

// Add user directory in /home/
if (_username isNotEqualTo "root") then
{
    try
    {
        [[], _filesystem, "/home/" + _username, "root", _username] call AE3_filesystem_fnc_createDir;
    } 
    catch
    {
        private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
        if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
        {
            diag_log format ["AE3 exception: %1", _exception];
            ["AE3 exception: %1", _exception] call BIS_fnc_error;
        }
        else
        {
            throw _exception;
        };
    };
};

// resync userlist and filesystem
_computer setVariable ["AE3_filesystem", _filesystem];
_computer setVariable ["AE3_Userlist", _userlist, true];
