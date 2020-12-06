params ["_entity"];

_standbyTime = 3;

[
	_standbyTime,
	[_entity], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_color = "#(argb,8,8,3)color(0.5,0.5,0.5,1.0,co)";

		_entity = _args select 0;

		_entity setObjectTextureGlobal [1, _color];

		_entity setVariable ['AE3_powerState', 1, true];
	},
	{},
	("Standby")
] call ace_common_fnc_progressBar;