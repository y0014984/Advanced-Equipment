params ["_entity", ["_silent", true]];

private _powerState = _entity getVariable 'AE3_powerState';

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
	_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_0.paa"];
	_entity setVariable ["_shuttingDownTextureIndex", 0];

	[
		_turnOffTime,
		[_entity, _color], 
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
			
			_entity = _args select 0;
			_color = _args select 1;

			_entity setObjectTextureGlobal [1, _color];

			_handle = [_entity] spawn AE3_armaos_fnc_playComputerStopSound;

			_entity setVariable ['AE3_powerState', 0, true];

			_entity setVariable ["history", [], true];
		},
		{},
		"Shutdown",
		{
			params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

			_entity = _args select 0;

			_shuttingDownTextureIndex = _entity getVariable ["_shuttingDownTextureIndex", -1];

			_elapsedTimePercent = _elapsedTime / _totalTime;

			switch (true) do
			{
				case ((_elapsedTimePercent >= 0.25) && (_shuttingDownTextureIndex < 1)):
				{
					_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_1.paa"];
					_entity setVariable ["_shuttingDownTextureIndex", 1];
				};
				case ((_elapsedTimePercent >= 0.5) && (_shuttingDownTextureIndex < 2)):
				{
					_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_2.paa"];
					_entity setVariable ["_shuttingDownTextureIndex", 2];
				};
				case ((_elapsedTimePercent >= 0.75) && (_shuttingDownTextureIndex < 3)):
				{
					_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Shutting_Down_3.paa"];
					_entity setVariable ["_shuttingDownTextureIndex", 3];
				};
			};
		}
	] call ace_common_fnc_progressBar;
};

true;