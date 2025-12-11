/*
 * Author: Root, y0014984
 * Description: Handles the Zeus 'Add User' module interface events (onLoad/onUnload). Runs locally on the Zeus curator's machine.
 * Creates a new user account on the target computer with the specified username and password.
 * The module must be placed on a computer object and will be deleted after processing.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The Zeus module display
 * 1: _exitCode <NUMBER> - Exit code (1 = OK, 2 = Cancel)
 * 2: _event <STRING> - Event type ("onLoad" or "onUnload")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 1, "onUnload"] call AE3_main_fnc_zeus_module_addUser;
 *
 * Public: No
 */

params ["_display", "_exitCode", "_event"];

private _module = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _module) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") exitWith
{
    private _result = [_display] call AE3_main_fnc_zeus_checkForComputer;
    _result params ["_status", "_computer"];

    if (_status isEqualTo "SUCCESS") then
    {
        // add computer variable to display namespace
        _display setVariable ["AE3_linkedComputer", _computer];
    }
    else
    {
        // close display
        _display closeDisplay 2; // 2 = cancel
    };
};

/* ---------------------------------------- */

if (_event isEqualTo "onUnload") exitWith
{
    private _computer = _display getVariable ["AE3_linkedComputer", objNull];
    if ((isNull _computer) || (_exitCode == 2)) exitWith
    {
        // delete module if dialog cancelled or computer not linked to module
        deleteVehicle _module;
    };

    // get username and password from UI
    private _usernameCtrl = _display displayCtrl 1401;
    private _passwordCtrl = _display displayCtrl 1402;
    private _username = ctrlText _usernameCtrl;
    private _password = ctrlText _passwordCtrl;

    // check for empty but mandatory input fields
    // module is still there an could be opened and filled in with valid input
    // but currently, this case will be catched by UI logic, defined directly in config
    if(_username isEqualTo "") exitWith { [objNull, localize "STR_AE3_Main_Zeus_UsernameMissing"] call BIS_fnc_showCuratorFeedbackMessage; };
    if(_password isEqualTo "") exitWith { [objNull, localize "STR_AE3_Main_Zeus_PasswordMissing"] call BIS_fnc_showCuratorFeedbackMessage; };

    // check for not allowed spaces in username
    if((_username find " ") != -1) exitWith { [objNull, localize "STR_AE3_Main_Zeus_UsernameContainsSpaces"] call BIS_fnc_showCuratorFeedbackMessage; };

    // Wait for filesystem to be ready before adding user
    [_computer, _username, _password, _module] spawn {
        params ["_computer", "_username", "_password", "_module"];

        // Wait for filesystem initialization (10 second timeout)
        private _filesystemReady = [_computer, 10] call AE3_main_fnc_waitForFilesystem;

        if (!_filesystemReady) exitWith {
            [objNull, "Filesystem not ready. Please wait and try again."] call BIS_fnc_showCuratorFeedbackMessage;
            deleteVehicle _module;
        };

        // Add user to computer
        [_computer, _username, _password] remoteExecCall ["AE3_armaos_fnc_computer_addUser", 2];

        private _message = format ["'%1': %2 '%3': %4", localize "STR_AE3_Main_Zeus_Username", _username, localize "STR_AE3_Main_Zeus_Password", _password];
        [localize "STR_AE3_Main_Zeus_UserAdded", _message, 5] call BIS_fnc_curatorHint;

        // Delete module
        deleteVehicle _module;
    };
};

/* ---------------------------------------- */
