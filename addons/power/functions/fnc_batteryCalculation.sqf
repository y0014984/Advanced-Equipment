/**
 * Calculates and sets the new battery level.
 * 
 * Arguments:
 * 0: Battery Object <OBJECT>
 *
 * Returns:
 * 0: Power state <BOOL>
 * 1: Power output <FLOAT>
 */

params ["_battery"];

private _class = typeOf _battery;
private _batteryCapacity = _battery getVariable 'AE3_batteryCapacity';
private _recharging = _battery getVariable 'AE3_recharging';

private _powerCableDevice = _battery getVariable ["AE3_powerCableDevice", nil];

private _powerState = _battery getVariable "AE3_powerState";
private _consumption = _battery getVariable ["AE3_powerReq", 0];

private _batteryLevel = _battery getVariable "AE3_batteryLevel";
private _change = 0;

if (!isNil "_powerCableDevice") then
{
	if (_powerCableDevice getVariable ["AE3_powerState", 0] == 1) then
	{
		_change = _recharging;
	};
};

if (_powerState != 0) then
{
	_change = _change - _consumption;
};

private _newBatteryLevel = _batteryLevel + _change;

if(_newBatteryLevel > _batteryCapacity) then
{
	_newBatteryLevel = _batteryCapacity;
	_battery setVariable ['AE3_powerDraw', _consumption, True];
}else 
{
	_battery setVariable ['AE3_powerDraw', _recharging, True];

	if(_newBatteryLevel < 0) then {
		_newBatteryLevel = 0;
		_powerState = 0;
	};
};

_battery setVariable ['AE3_batteryLevel', _newBatteryLevel, true];
_battery setVariable ['AE3_powerState', _powerState, true];

[_powerState == 1, _newBatteryLevel];