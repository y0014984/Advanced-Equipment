params ["_entity"];


_powerState = _entity getVariable 'AE3_powerState';

_turnOnTime = 0;

switch (_powerState) do
{
	case 0: { _turnOnTime = 15; };
	case 2: { _turnOnTime = 3; };
	default {};
};

_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_0.paa"];
_entity setVariable ["_bootingTextureIndex", 0];

[
	_turnOnTime,
	[_entity], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_entity = _args select 0;

		_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_On.paa"];

		_handle = [_entity] spawn AE3_armaos_fnc_playComputerStartSound;

		//_entity setVariable ['AE3_powerState', 1, true];

	},
	{},
	"Booting",
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];

		_entity = _args select 0;

		_bootingTextureIndex = _entity getVariable ["_bootingTextureIndex", -1];

		_elapsedTimePercent = _elapsedTime / _totalTime;

		switch (true) do
		{
			case ((_elapsedTimePercent >= 0.25) && (_bootingTextureIndex < 1)):
			{
				_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_1.paa"];
				_entity setVariable ["_bootingTextureIndex", 1];
			};
			case ((_elapsedTimePercent >= 0.5) && (_bootingTextureIndex < 2)):
			{
				_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_2.paa"];
				_entity setVariable ["_bootingTextureIndex", 2];
			};
			case ((_elapsedTimePercent >= 0.75) && (_bootingTextureIndex < 3)):
			{
				_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Booting_3.paa"];
				_entity setVariable ["_bootingTextureIndex", 3];
			};
		};
	}
] call ace_common_fnc_progressBar;

true;