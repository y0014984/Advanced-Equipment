/*
 * Author: Root
 * Description: Handles the Zeus 'Add Security Commands' module interface events (onLoad/onUnload). Runs locally on the Zeus curator's machine.
 * Adds security/hacking tools (crypto and crack commands) to the target computer.
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
 * [_display, 1, "onUnload"] call AE3_main_fnc_zeus_module_addSecurityCommands;
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

    // get isCrack and isCrypto from UI
    private _isCryptoCtrl = _display displayCtrl 1401;
    private _isCrackCtrl = _display displayCtrl 1402;
    private _isCrypto = cbChecked _isCryptoCtrl;
    private _isCrack = cbChecked _isCrackCtrl;

    // Wait for filesystem to be ready before adding security commands
    [_computer, _isCrypto, _isCrack, _module] spawn {
        params ["_computer", "_isCrypto", "_isCrack", "_module"];

        // Wait for filesystem initialization (10 second timeout)
        private _filesystemReady = [_computer, 10] call AE3_main_fnc_waitForFilesystem;

        if (!_filesystemReady) exitWith {
            [objNull, "Filesystem not ready. Please wait and try again."] call BIS_fnc_showCuratorFeedbackMessage;
            deleteVehicle _module;
        };

        // Add security commands to computer
        [_computer, _isCrypto, _isCrack] remoteExecCall ["AE3_armaos_fnc_computer_addSecurityCommands", 2];

        private _message = format ["crypto: %1 crack: %2", _isCrypto, _isCrack];
        [localize "STR_AE3_Main_Zeus_SecurityCommandsAdded", _message, 5] call BIS_fnc_curatorHint;

        // Delete module
        deleteVehicle _module;
    };
};

/* ---------------------------------------- */
