// _result = [_options, _consoleInput] call Y00_fnc_print;

params ["_options", "_consoleInput"];

_pointer = _consoleInput getVariable "pointer";
_filesystem = _consoleInput getVariable "filesystem";

_result = [""];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount > 1):
	{
		//hint "Case 1";
		
		_result = ["   Command: open too many options"];
		_result breakOut "main";
	};
	case (_optionsCount == 1):
	{
		//hint "Case 2";
		
		_optionsString = _options select 0;
		
		if ((_optionsString select [0, 1]) isEqualTo "/") then
		{
			_pointer = _optionsString;
		}
		else
		{
			_pointer = _pointer + _optionsString;
		};
	};
	case (_optionsCount == 0):
	{
		//hint "Case 3";
		
		_result = ["   Command: open too few options"];
		_result breakOut "main";
	};
};

_result = ["   Command: print " + _pointer];

_counter = 0;
_content = [];

{
	_file = _x select 0;
	if ((_file find _pointer) == 0) then
	{
		_item = [_file, count _pointer] call BIS_fnc_trimString;

		if ((_item find "/") == 0) then
		{
			_item = [_item, 1] call BIS_fnc_trimString;
		};
		if ((_item find "/") != -1) then
		{
			_item = [_item, 0, _item find "/"] call BIS_fnc_trimString;
		};
		_counter = _counter + 1;
		_content append (_x select 1);
	};
} forEach _filesystem;

if (_counter == 0) then {_result = [(_result select 0) + " - file not found"]};

if (_counter == 1) then {_result append _content;};

if (_counter > 1) then {_result = [(_result select 0) + " - error"]};

_result;