//_handle = [this, _class, _name, _mode, _totalTime] execVM "Scripts\OpenCloseAction.sqf";

params ["_object", "_class", "_name", "_mode", "_totalTime"];

_modeString = "";
_modeVar = "";

switch (_mode) do
{
    case 1: { _modeString = "Open"; _modeVar = "open"; };
    case 2: { _modeString = "Close"; _modeVar = "close"; };
    default { hint "default" };
};

_action =
	[
		_modeVar,
		_modeString + " " + (_name),
		"",
		{
			params ["_target", "_player", "_params"];
			
			_class = _params select 0;
			_name = _params select 1;
			_modeString = _params select 2;
			_totalTime = _params select 3;
			
			[
				_totalTime,
				[_target, _class], 
				{
					params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
					
					_target = _args select 0;
					_class = _args select 1;
					_handle = [_target, _class] execVM "\z\ae3\addons\main\scripts\OpenClose.sqf";
				},
				{},
				(_modeString + " " + _name)
			] call ace_common_fnc_progressBar;
		},
		{
			true;
		},
		{},
		[_class, _name, _modeString, _totalTime]
	] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;