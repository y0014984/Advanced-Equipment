params ["_options", "_consoleInput"];

_pointer = _consoleInput getVariable "pointer";
_filesystem = _consoleInput getVariable "filesystem";

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount > 1):
	{
		_result = ["   Command: print - too many options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		_result = ["   Command: print - too few options"];
		_result breakOut "main";
	};
	case (_optionsCount == 1):
	{
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

		_textBlob = _x select 1;

		_textArray = _textBlob splitString toString [10];

		_content append (_textArray);
	};
} forEach _filesystem;

if (_counter == 0) then {_result = [(_result select 0) + " - file not found"]};

if (_counter == 1) then {_result append _content;};

if (_counter > 1) then {_result = [(_result select 0) + " - error"]};

_result;