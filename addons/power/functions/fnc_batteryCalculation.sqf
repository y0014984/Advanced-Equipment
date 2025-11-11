/*
 * Author: Root
 * Description: Calculates and updates the battery level based on power consumption and recharging rate. Called every second by the power provider handler. Handles both charging (from connected power source) and discharging (when powering devices). Power values are in kWh.
 *
 * Arguments:
 * 0: _battery <OBJECT> - Battery object to calculate
 *
 * Return Value:
 * [Power state (true if battery has charge), Current battery level in kWh] <ARRAY>
 *
 * Example:
 * private _batteryStatus = [_battery] call AE3_power_fnc_batteryCalculation;
 *
 * Public: Yes
 */

params ["_battery"];

private _class = typeOf _battery;
private _batteryCapacity = _battery getVariable 'AE3_power_batteryCapacity';
private _recharging = _battery getVariable 'AE3_power_recharging';
private _parent = _battery getVariable 'AE3_power_parent';

if(!isNil "_parent") then // is internal battery
{
	if(!isNil {_parent getVariable "AE3_power_connectedDevices"}) then // is parent generator
	{
		_recharging = _parent getVariable ['AE3_power_powerCapacity', 0];
	};
};

private _powerCableDevice = _battery getVariable ["AE3_power_powerCableDevice", nil];

private _powerState = _battery getVariable "AE3_power_powerState";
private _consumption = _battery getVariable ["AE3_power_powerReq", 0];

private _batteryLevel = _battery getVariable "AE3_power_batteryLevel";
private _change = 0;

if (!isNil "_powerCableDevice") then
{
	if (_powerCableDevice getVariable ["AE3_power_powerState", 0] == 1) then
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
	_battery setVariable ['AE3_power_powerDraw', _consumption];
}else 
{
	_battery setVariable ['AE3_power_powerDraw', _recharging];

	if(_newBatteryLevel < 0) then {
		_newBatteryLevel = 0;
		_powerState = 0;
	};
};

_battery setVariable ['AE3_power_batteryLevel', _newBatteryLevel];
_battery setVariable ['AE3_power_powerState', _powerState, true];

[_powerState == 1, _newBatteryLevel];
