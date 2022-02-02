/**
 * Initializes a consumer.
 * 
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Power consumption in [kW] <NUMBER>
 *
 * Results:
 * None
*/

params['_entity', '_powerConsumption'];

private _turnOnWrapper = {
	params['_target', ['_args', []]];

	if([_target, _target getVariable 'AE3_powerConsumption'] call AE3_power_fnc_updateSelfPower) exitWith {};

	_turnOnFnc =  _target getVariable "AE3_power_fnc_turnOn";
	_result = [_target] + _args call _turnOnFnc;

	if(_result) then
	{
		_target setVariable ['AE3_powerState', 1, true];
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
		_target setVariable ['AE3_powerState', 0, true];

		[_target, 0] call AE3_power_fnc_updateSelfPower;
	};

};


_entity setVariable ["AE3_power_fnc_turnOnWrapper", _turnOnWrapper, true];
_entity setVariable ["AE3_power_fnc_turnOffWrapper", _turnOffWrapper, true];

_entity setVariable ["AE3_powerConsumption", _powerConsumption, true];
_entity setVariable ['AE3_powerDraw', 0, true];