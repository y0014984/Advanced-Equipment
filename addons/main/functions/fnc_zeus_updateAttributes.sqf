params ["_display"];

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

private _batteryLevelCtrl = _display displayCtrl 1900;
private _batteryLevelPercent = sliderPosition _batteryLevelCtrl;

hint format ["Battery Level (%1): %2", "%", _batteryLevelPercent];

private _battery = _entity;
private _hasInternal = _battery getVariable "AE3_power_hasInternal";
if (_hasInternal) then { _battery = _battery getVariable "AE3_power_internal"; };

[_battery, _batteryLevelPercent] call AE3_power_fnc_setBatteryLevel;