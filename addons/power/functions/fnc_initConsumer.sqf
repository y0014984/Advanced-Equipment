/*
 * Author: Root
 * Description: Initializes a power consumer device with consumption and standby power requirements. Creates wrapper functions that check power availability before turning on and update power draw when changing states. Power consumption is in kWh.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Consumer device object
 * 1: _powerConsumption <NUMBER> - Active power consumption in kWh
 * 2: _standbyConsumption <NUMBER> - Standby power consumption in kWh
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, 0.065, 0.01] call AE3_power_fnc_initConsumer;
 *
 * Public: No
 */

params['_entity', '_powerConsumption', '_standbyConsumption'];

private _turnOnWrapper = {
	params['_target', ['_args', []]];

	if([_target, _target getVariable 'AE3_power_powerConsumption'] call AE3_power_fnc_updateSelfPower) exitWith {};

	_turnOnFnc =  _target getVariable "AE3_power_fnc_turnOn";
	_result = [_target] + _args call _turnOnFnc;

	if(_result) then
	{
		_target setVariable ['AE3_power_powerState', 1, true];
	}else
	{
		[_target, 0] call AE3_power_fnc_updateSelfPower;
	}

	
};

private _turnOffWrapper = {
	params['_target', ['_args', []]];

	_turnOffFnc =  _target getVariable "AE3_power_fnc_turnOff";
	_result = [_target] + _args call _turnOffFnc;


	if(_result) then
	{
		_target setVariable ['AE3_power_powerState', 0, true];

		[_target, 0] call AE3_power_fnc_updateSelfPower;
	};

};

private _standbyWrapper = {
	params['_target', ['_args', []]];

	if([_target, _target getVariable 'AE3_power_standbyConsumption'] call AE3_power_fnc_updateSelfPower) exitWith {};

	_standbyFnc =  _target getVariable "AE3_power_fnc_standby";
	_result = [_target] + _args call _standbyFnc;

	if(_result) then
	{
		_target setVariable ['AE3_power_powerState', 2, true];
	};
};

if(isServer) then
{
	_entity setVariable ["AE3_power_powerConsumption", _powerConsumption, true];
	_entity setVariable ["AE3_power_standbyConsumption", _standbyConsumption, true];
	_entity setVariable ['AE3_power_powerDraw', 0];
};

_entity setVariable ["AE3_power_fnc_turnOnWrapper", _turnOnWrapper];
_entity setVariable ["AE3_power_fnc_turnOffWrapper", _turnOffWrapper];
_entity setVariable ["AE3_power_fnc_standbyWrapper", _standbyWrapper];
