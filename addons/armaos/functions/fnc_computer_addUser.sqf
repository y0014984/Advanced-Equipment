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

// Add user to userlist FIRST to ensure user is added even if directory creation fails
_userlist set [_username, _password];
_computer setVariable ["AE3_Userlist", _userlist, true];

// Add user directory in /home/
if (_username isNotEqualTo "root") then
{
    try
    {
        // Ensure /home exists first (might not exist if other mods created files there)
        try {
            [[], _filesystem, "/home", "root", "root"] call AE3_filesystem_fnc_createDir;
        } catch {
            // /home might already exist - that's fine, continue
        };

        // Now create the user directory
        [[], _filesystem, "/home/" + _username, "root", _username] call AE3_filesystem_fnc_createDir;
    }
    catch
    {
        private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
        if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
        {
            // Directory already exists (another mod might have created it) - this is OK
            diag_log format ["AE3: User directory for '%1' already exists, skipping creation", _username];
        }
        else
        {
            // Some other error occurred - log it but don't fail the entire function
            diag_log format ["AE3 WARNING: Failed to create user directory for '%1': %2", _username, _exception];
            ["AE3 WARNING: Failed to create user directory for '%1': %2", _username, _exception] call BIS_fnc_error;
        };
    };
};

// Sync filesystem
_computer setVariable ["AE3_filesystem", _filesystem];
