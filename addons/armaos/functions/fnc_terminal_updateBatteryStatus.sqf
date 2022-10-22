/**
 * Updates the Battery Symbol in the upper right corner of the terminal application according to the battery status every 15 seconds.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 1: Console Dialog <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer", "_consoleDialog"];

private _battery = _computer getVariable ["AE3_power_internal", false];

private _batteryCtrl = _consoleDialog displayCtrl 1050;

while { true } do
{
    private _params = [_battery] call AE3_power_fnc_getBatteryLevel;

    _params params ["_batteryLevel", "_batteryLevelPercent"];

    private _value = 0;
    if (_batteryLevelPercent >= 0 && _batteryLevelPercent < 25) then { _value = 0; };
    if (_batteryLevelPercent >= 25 && _batteryLevelPercent < 50) then { _value = 25; };
    if (_batteryLevelPercent >= 50 && _batteryLevelPercent < 75) then { _value = 50; };
    if (_batteryLevelPercent >= 75 && _batteryLevelPercent < 100) then { _value = 75; };
    if (_batteryLevelPercent >= 95) then { _value = 100; };

    hint format ["Battery Value Symbol: %1", _value];

    _batteryCtrl ctrlSetText format ["\z\ae3\addons\armaos\images\AE3_battery_%1_percent.paa", _value];

    sleep 15;
};