params ["_entity"];

private _standbyTime = 3;

[
	_standbyTime,
	[_entity], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_entity = _args select 0;

		_entity setObjectTextureGlobal [1, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_Standby.paa"];

		_handle = [_entity] spawn AE3_armaos_fnc_playComputerStandbySound;

		_entity setVariable ['AE3_power_powerState', 2, true];
	},
	{},
	("Standby")
] call ace_common_fnc_progressBar;

true;