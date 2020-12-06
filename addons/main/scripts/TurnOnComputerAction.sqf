params ["_entity"];

_batteryLevel = _entity getVariable "AE3_batteryLevel";

if (_batteryLevel > 0) then
{
	_powerState = _entity getVariable 'AE3_powerState';

	_turnOnTime = 0;

	switch (_powerState) do
	{
		case 0: { _turnOnTime = 15; };
		case 1: { _turnOnTime = 3; };
		default {};
	};

	[
		_turnOnTime,
		[_entity], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_color = "#(argb,8,8,3)color(1,1,1,1.0,co)";

			_entity = _args select 0;

			_entity setObjectTextureGlobal [1, _color];

			_entity setVariable ['AE3_powerState', 2, true];
		},
		{},
		("Turn on / Booting")
	] call ace_common_fnc_progressBar;
};