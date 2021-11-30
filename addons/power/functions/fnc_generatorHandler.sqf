/**
 * Creates generator loop.
 * 
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: Gen. Function which calcs power state and output <FUNC>
 * 2: Gen. Function which handles turnoff <FUNC>
 * 
 * Return:
 * NULL
 */
params['_generator', '_generatorFnc', '_generatorTurnoff'];

private _handle = [
	{
		private _handle = _this select 1;
		(_this select 0) params ['_generator', '_generatorFnc', '_generatorTurnoff'];

		([_generator] call _generatorFnc) params['_powerState', '_power'];
		
		hint ((str _powerState) + " " + (str _power));

		if(!_powerState) then
		{
			[_generator, true] call _generatorTurnoff;
		};
	},
	1,
	[_generator, _generatorFnc, _generatorTurnoff]
] call CBA_fnc_addPerFrameHandler;

_generator setVariable ['AE3_generatorHandle', _handle];