params ["_object", "_name", "_axis", "_totalTime"];

_action =
	[
		"Rotate",
		"Drehen" + " " + _name,
		"",
		{
			params ["_target", "_player", "_params"];
			
			_name = _params select 0;
			_axis = _params select 1;
			_totalTime = _params select 2;
			
			[
				_totalTime,
				[_target,  _axis], 
				{
					params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
					
					_target = _args select 0;
					_axis = _args select 1;
					_handle = [_target, _axis] execVM "\z\ae3\addons\main\scripts\Rotate.sqf";
				},
				{},
				("Drehen" + " " + _name)
			] call ace_common_fnc_progressBar;
		},
		{
			true;
		},
		{},
		[_name, _axis, _totalTime]
	] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;