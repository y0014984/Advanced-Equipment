//_handle = [_object, _name, _mode, _totalTime] execVM "Scripts\OpenCloseActionTable.sqf";

params ["_object", "_name", "_mode", "_totalTime"];

_modeString = "";
_modeVar = "";

_object setVariable ["OpenClosedState", _mode, true];

switch (_mode) do
{
    case 0: { _modeString = "Open"; _modeVar = "open"; };
    case 1: { _modeString = "Close"; _modeVar = "close"; };
    default { hint "default" };
};

_action =
	[
		_modeVar,
		_modeString + " " + (_name),
		"",
		{
			params ["_target", "_player", "_params"];
			
			_name = _params select 0;
			_modeString = _params select 1;
			_totalTime = _params select 2;
			
			_mode = _target getVariable "OpenClosedState";
			
			[
				_totalTime,
				[_target, _mode], 
				{
					params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
					
					_target = _args select 0;
					_mode = _args select 1;
					
					_handle = [_target, _mode] execVM "\z\ae3\addons\main\scripts\OpenCloseTable.sqf";
					
					switch (_mode) do
					{
						case 0: { _mode = 1; };
						case 1: { _mode = 0; };
						default { hint "default" };
					};
					
					_target setVariable ["OpenClosedState", _mode, true];
				},
				{},
				(_modeString + " " + _name)
			] call ace_common_fnc_progressBar;
		},
		{
			true;
		},
		{},
		[_name, _modeString, _totalTime],
		"",
		0,
		[false, false, false, false, false], 
		{
			params ["_target", "_player", "_params", "_actionData"];
			
			_name = _params select 0;
			
			_mode = _target getVariable "OpenClosedState";

			if (!isNil "_mode") then
			{
				_modeString = "";
				_modeVar = "";

				switch (_mode) do
				{
					case 0: { _modeString = "Open"; _modeVar = "open"; };
					case 1: { _modeString = "Close"; _modeVar = "close"; };
					default { hint "default" };
				};
				
				// Modify the action - index 1 is the display name, 2 is the icon...
				_actionData set [1, _modeString + " " + (_name)];
			};
		}
	] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;