/**
 * PRIVATE
 *
 * This function is assigned to the 'onLoad' and 'onUnload' Events of the Zeus Module Interface: addUser
 * This function runs local on the computer of the curator/zeus because it is UI triggered.
 * The function makes changes to the asset according the the user input.
 * This module needs to be placed onto a computer.
 * After processing the module will be deleted.
 *
 * Arguments:
 * 1: Display <OBJECT>
 * 2: Exit Code <NUMBER>
 * 3: Event <STRING>
 *
 * Results:
 * None
 *
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
    if(_username isEqualTo "") exitWith { [objNull, "Username missing"] call BIS_fnc_showCuratorFeedbackMessage; };
    if(_password isEqualTo "") exitWith { [objNull, "Password missing"] call BIS_fnc_showCuratorFeedbackMessage; };

    // check for not allowed spaces in username
    if((_username find " ") != -1) exitWith { [objNull, "Username contains forbidden spaces"] call BIS_fnc_showCuratorFeedbackMessage; };

    // add user to computer
    [_computer, _username, _password] remoteExecCall ["AE3_armaos_fnc_computer_addUser", 2];

    private _message = format ["'%1': %2 '%3': %2", localize "STR_AE3_Main_Zeus_Username", _username, localize "STR_AE3_Main_Zeus_Password", _password];
    [localize "STR_AE3_Main_Zeus_UserAdded", _message, 5] call BIS_fnc_curatorHint;

    // delete module if dialog cancelled or computer not linked to module
    deleteVehicle _module;
};

/* ---------------------------------------- */