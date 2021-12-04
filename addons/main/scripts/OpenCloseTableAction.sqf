params ["_object", "_mode", "_totalTime"];

[
	_totalTime,
	[_object, _mode], 
	{
		params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
		
		_object = _args select 0;
		_mode = _args select 1;
		
		_handle = [_object, _mode] execVM "\z\ae3\addons\main\scripts\OpenCloseTable.sqf";
		
		switch (_mode) do
		{
			case 0: { _mode = 1; };
			case 1: { _mode = 0; };
			default { hint "default" };
		};
		
		_object setVariable ["OpenClosedState", _mode, true];
	},
	{},
	("Interaktion Tisch")
] call ace_common_fnc_progressBar;