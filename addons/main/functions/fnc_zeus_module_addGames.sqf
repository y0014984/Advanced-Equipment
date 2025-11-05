/**
 * PRIVATE
 *
 * This function is assigned to the 'onLoad' and 'onUnload' Events of the Zeus Module Interface: addGames
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

    // get isSnake from UI
    private _isSnakeCtrl = _display displayCtrl 1401;
    private _isSnake = cbChecked _isSnakeCtrl;

    // Wait for filesystem to be ready before adding games
    [_computer, _isSnake, _module] spawn {
        params ["_computer", "_isSnake", "_module"];

        // Wait for filesystem initialization (10 second timeout)
        private _filesystemReady = [_computer, 10] call AE3_main_fnc_waitForFilesystem;

        if (!_filesystemReady) exitWith {
            [objNull, "Filesystem not ready. Please wait and try again."] call BIS_fnc_showCuratorFeedbackMessage;
            deleteVehicle _module;
        };

        // Add games to computer
        [_computer, _isSnake] remoteExecCall ["AE3_armaos_fnc_computer_addGames", 2];

        private _message = format ["snake: %1 ", _isSnake];
        [localize "STR_AE3_Main_Zeus_GamesAdded", _message, 5] call BIS_fnc_curatorHint;

        // Delete module
        deleteVehicle _module;
    };
};

/* ---------------------------------------- */
