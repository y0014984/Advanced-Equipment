/**
 * Creates generator loop.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: Gen. Function which calcs power state and output <FUNC>
 * 
 * Return:
 * NULL
 */
params['_generator', '_generatorFnc'];

_generator setVariable ['AE3_powerCapacity', 0, true];
_generatorTurnoff = _generator getVariable 'AE3_power_fnc_turnOffWrapper';

private _handle = [
	{
		private _handle = _this select 1;
		(_this select 0) params ['_generator', '_generatorFnc', '_generatorTurnoff'];

		([_generator] call _generatorFnc) params['_powerState', '_newPower'];
		
		if(!_powerState) then
		{
			[_generator, [true]] call _generatorTurnoff;
		};

		if(_newPower != (_generator getVariable ['AE3_powerCapacity', 0])) then
		{
			_generator setVariable ['AE3_powerCapacity', _newPower, true];
			
			if(_newPower < _generator getVariable ['AE3_powerReq', 0]) then
			{
				[_generator, [true]] call _generatorTurnoff;
			}
		}
	},
	1,
	[_generator, _generatorFnc, _generatorTurnoff]
] call CBA_fnc_addPerFrameHandler;

if(_handle < 0) exitWith {};

_generator setVariable ['AE3_generatorHandle', _handle];
//_generator setVariable ['AE3_powerState', 1, True];

private _connectedDevices = _generator getVariable ["AE3_connectedDevices", []];

/*
{
	_powerState = _x getVariable ["AE3_powerState", 0];
	if (_powerState == 0) then { _x setVariable ["AE3_powerState", 1, true]; };
} forEach _connectedDevices;
*/