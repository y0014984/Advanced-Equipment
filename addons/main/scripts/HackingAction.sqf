//_handle = [this, _name, _totalTime] execVM "Scripts\HackingAction.sqf";

params ["_object", "_name", "_totalTime"];

_action =
	[
		"hacking",
		"Hacking" + " " + (_name),
		"",
		{
			params ["_target", "_player", "_params"];
			
			_name = _params select 0;
			_totalTime = _params select 1;
			
			[
				_totalTime,
				[], 
				{
					params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
					
					_handle = [] execVM "\z\ae3\addons\main\scripts\Hacking.sqf";
				},
				{},
				("Hacking" + " " + _name)
			] call ace_common_fnc_progressBar;
		},
		{
			true;
		},
		{},
		[_name, _totalTime]
	] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;