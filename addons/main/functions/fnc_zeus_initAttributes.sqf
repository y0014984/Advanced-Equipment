params ["_display"];

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

private _battery = _entity;

// The interface is shown up too fast; waitUntil the variables are valid
// The interface is faster then our init process for object variables
// on my test system it takes 3 waitUntil cycles for the variables to be available

[_display, _battery] spawn
{
    params ["_display", "_battery"];

    private _counter = 0;

    waitUntil { !isNil { _battery getVariable "AE3_power_hasInternal" }; };

    private _hasInternal = _battery getVariable "AE3_power_hasInternal";
    if (_hasInternal) then { _battery = _battery getVariable "AE3_power_internal"; };

    _result = [_battery] call AE3_power_fnc_getBatteryLevel;
    _result params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];

    private _batteryLevelSliderCtrl = _display displayCtrl 1900;
    _batteryLevelSliderCtrl sliderSetPosition _batteryLevelPercent;
    private _batteryLevelCtrl = _display displayCtrl 1401;
    _batteryLevelCtrl ctrlSetText format ['%1%2', _batteryLevelPercent, '%'];
};