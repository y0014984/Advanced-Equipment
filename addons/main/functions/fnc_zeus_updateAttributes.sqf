params ["_display", "_exitCode"];
// _exitCode: ok = 1, cancel = 2

/* ======================================== */

private _statusUpdateHandle = _display getVariable ["AE3_statusUpdateHandle", scriptNull];
if (!isNull _statusUpdateHandle) then { terminate _statusUpdateHandle; };

if (_exitCode == 1) then
{
    /* ======================================== */
    
    private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
    if (isNull _entity) exitWith {};

    private _battery = _entity;
    private _hasInternal = _entity getVariable "AE3_power_hasInternal";
    if (_hasInternal) then { _battery = _entity getVariable "AE3_power_internal"; };

    private _generator = _entity;

    /* ======================================== */

    private _message = "";

    /* ======================================== */

    // if asset has battery, update battery level
    if (!isNil { _battery getVariable "AE3_power_batteryCapacity" }) then
    {
        private _batteryLevelCtrl = _display displayCtrl 1900;
        private _batteryLevelPercent = sliderPosition _batteryLevelCtrl;

        _message = _message + format ["New Battery Level: %1%2 ", _batteryLevelPercent, "%"];

        [_battery, _batteryLevelPercent] call AE3_power_fnc_setBatteryLevel;
    };

    /* ======================================== */

    // if asset has fuel, update fuel level
    if (!isNil { _generator getVariable "AE3_power_fuelCapacity" }) then
    {
        private _fuelLevelCtrl = _display displayCtrl 1901;
        private _fuelLevelPercent = sliderPosition _fuelLevelCtrl;

        _message = _message + format ["New Fuel Level: %1%2 ", _fuelLevelPercent, "%"];

        [_generator, _fuelLevelPercent] call AE3_power_fnc_setFuelLevel;
    };

    /* ======================================== */

    ["AE3 Asset Attributes changed", _message, 5] call BIS_fnc_curatorHint;

    /* ======================================== */
};