//_handle = [_object, _name, _mode, _totalTime] execVM "Scripts\OnOffAction.sqf";

params ["_object", "_name", "_texture", "_mode", "_totalTime"];

_modeString = "";
_modeVar = "";

_object setVariable [format ["OnOffState%1", _texture], _mode, true];

switch (_mode) do
{
    case 1: { _modeString = "Turn On"; _modeVar = "turnOn"; };
    case 2: { _modeString = "Turn Off"; _modeVar = "turnOff"; };
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
			_texture = _params select 3;
			
			_mode = _target getVariable format ["OnOffState%1", _texture];
			
			[
				_totalTime,
				[_target, _texture, _mode], 
				{
					params ["_args", "_elapsedTime", "_totalTime", "_errorCode"];
					
					_target = _args select 0;
					_texture = _args select 1;
					_mode = _args select 2;
					
					_handle = [_target, _texture, _mode] execVM "\z\ae3\addons\main\scripts\OnOff.sqf";
					
					switch (_mode) do
					{
						case 1: { _mode = 2; };
						case 2: { _mode = 1; };
						default { hint "default" };
					};
					
					_target setVariable [format ["OnOffState%1", _texture], _mode, true];
				},
				{},
				(_modeString + " " + _name)
			] call ace_common_fnc_progressBar;
		},
		{
			true;
		},
		{},
		[_name, _modeString, _totalTime, _texture],
		"",
		0,
		[false, false, false, false, false], 
		{
			params ["_target", "_player", "_params", "_actionData"];
			
			_name = _params select 0;
			_texture = _params select 3;
			
			_mode = _target getVariable format ["OnOffState%1", _texture];

			if (!isNil "_mode") then
			{
				_modeString = "";
				_modeVar = "";

				switch (_mode) do
				{
					case 1: { _modeString = "Turn On"; _modeVar = "turnOn"; };
					case 2: { _modeString = "Turn Off"; _modeVar = "turnOff"; };
					default { hint "default" };
				};
				
				// Modify the action - index 1 is the display name, 2 is the icon...
				_actionData set [1, _modeString + " " + (_name)];
			};
		}
	] call ace_interact_menu_fnc_createAction;
[_object, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;