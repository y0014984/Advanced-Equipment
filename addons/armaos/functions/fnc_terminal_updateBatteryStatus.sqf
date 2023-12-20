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

private _battery = _computer getVariable ["AE3_power_internal", false];

private _batteryCtrl = _consoleDialog displayCtrl 1050;
private _inputCtrl = _consoleDialog displayCtrl 1150;

// add variables to uiNamespace so they are accessable from control based action (battery symbol button)
uiNamespace setVariable ["AE3_Battery", _battery];
uiNamespace setVariable ["AE3_ConsoleInput", _inputCtrl];

_handle = 
    [
        {
            (_this select 0) params ["_computer", "_battery", "_batteryCtrl"];

            // We have to use 'spawn' inside 'perFrameEventHandler' because this is a scheduled environment, 
            // but 'getRemoteVar' in 'getBatteryLevel' needs unscheduled environment to work properly.
            // Otherwise throwing "suspending not allowd in this context" error.
            [_computer, _battery, _batteryCtrl] spawn 
            {
                params ["_computer", "_battery", "_batteryCtrl"];

                private _params = [_battery] call AE3_power_fnc_getBatteryLevel;

                _params params ["_batteryLevel", "_batteryLevelPercent"];

                private _value = 0;

                if (_batteryLevelPercent >= 95) then
                {
                    _value = 100;
                }
                else
                {
                    _value = (floor (_batteryLevelPercent / 25)) * 25;
                };

                private _oldValue = ctrlText _batteryCtrl;
    	        private _newValue = format ["\z\ae3\addons\armaos\images\AE3_battery_%1_percent.paa", _value];

                _batteryCtrl ctrlSetText _newValue;

                /* ------------- UI on Texture ------------ */

                if ((AE3_UiOnTexture) && !(_oldValue isEqualTo _newValue)) then
                {
                    [3, _computer, "AE3_armaos_fnc_terminal_uiOnTex_updateBatteryStatus", [_computer, _value]] call AE3_main_fnc_executeForPlayersInRange;
                };

                /* ---------------------------------------- */
            };
        }, 
        60, 
        [_computer, _battery, _batteryCtrl]
    ] call CBA_fnc_addPerFrameHandler;

_handle;