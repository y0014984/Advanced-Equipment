/**
 * Updates the Battery Symbol in the upper right corner of the terminal application according to the battery status every 15 seconds.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Console Dialog <OBJECT>
 *
 * Results:
 * 1: Per Frame Handler <HANDLE>
 */

params ["_computer", "_consoleDialog"];

_handle = 
    [
        {
            (_this select 0) params ["_computer", "_consoleDialog"];

            private _playersInRange = [3, _computer] call AE3_main_fnc_getPlayersInRange;

            // get values
            _outputControl ctrlSetStructuredText (composeText _output);

            private _consoleCtrl = _consoleDialog displayCtrl 1100;
            private _languageButtonCtrl = _consoleDialog displayCtrl 1310;
            private _batteryButtonCtrl = _consoleDialog displayCtrl 1050;

            {
                [_computer, _output] remoteExec ["AE3_armaos_fnc_terminal_uiOnTex_updateAll", _x];
            } forEach _playersInRange;
        }, 
        5, 
        [_computer, _consoleDialog]
    ] call CBA_fnc_addPerFrameHandler;

_handle;