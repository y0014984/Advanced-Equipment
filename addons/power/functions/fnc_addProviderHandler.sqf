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
params['_generator', '_generatorFnc', ['_internal', false]];

_generator setVariable ['AE3_power_powerCapacity', 0];

private _generatorTurnoff = {
	params ['_generator'];
	{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
	}forEach (_generator getVariable ['AE3_power_connectedDevices', []]);

};

if(!_internal) then
{
	_generatorTurnoff = _generator getVariable 'AE3_power_fnc_turnOffWrapper';
};

private _handle = [
	{
		private _handle = _this select 1;
		(_this select 0) params ['_generator', '_generatorFnc', '_generatorTurnoff'];

		([_generator] call _generatorFnc) params['_powerState', '_newPower'];
		
		if(!_powerState) then
		{
			[_generator, [true]] call _generatorTurnoff;
		};

		if(_newPower != (_generator getVariable ['AE3_power_powerCapacity', 0])) then
		{
			_generator setVariable ['AE3_power_powerCapacity', _newPower];
			
			if(_newPower < _generator getVariable ['AE3_power_powerReq', 0]) then
			{
				[_generator, [true]] call _generatorTurnoff;
			}
		}
	},
	1,
	[_generator, _generatorFnc, _generatorTurnoff]
] call CBA_fnc_addPerFrameHandler;

if(_handle < 0) exitWith {throw "GeneratorInitError";};

_generator setVariable ['AE3_power_generatorHandle', _handle];
