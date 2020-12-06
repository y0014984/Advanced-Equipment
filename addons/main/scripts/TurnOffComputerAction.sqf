params ["_entity", "_silent"];

_powerState = _entity getVariable 'AE3_powerState';

_turnOffTime = 0;

switch (_powerState) do
{
	case 1: { _turnOffTime = 15; };
	case 2: { _turnOffTime = 10; };
	default {};
};

_color = "#(argb,8,8,3)color(0,0,0,0.0,co)";

if (_silent) then 
{
			_entity setObjectTextureGlobal [1, _color];
			_entity setVariable ['AE3_powerState', 0, true];
}
else 
{
	[
		_turnOffTime,
		[_entity], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_entity = _args select 0;

			_entity setObjectTextureGlobal [1, _color];
			_entity setVariable ['AE3_powerState', 0, true];
		},
		{},
		("Turn Off / Shutdown")
	] call ace_common_fnc_progressBar;
};