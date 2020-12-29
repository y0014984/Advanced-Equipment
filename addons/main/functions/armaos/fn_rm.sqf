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
		_result = ["   Command: rm - too many options"];
		_result breakOut "main";
	};
	case (_optionsCount == 0):
	{
		_result = ["   Command: rm - too few options"];
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

_result = ["   Command: rm " + _pointer];

_counter = 0;
_fileToDeleteIndex = -1;

{
	_file = _x select 0;
	if ((_file find _pointer) == 0) then
	{
		_counter = _counter + 1;
		_fileToDeleteIndex = _forEachIndex;
	};
} forEach _filesystem;

if (_counter == 0) then {_result = [(_result select 0) + " - file not found"]};

// Multiple Files with the same path in Filesystem or Path == Folder with multiple Files
if (_counter > 1) then {_result = [(_result select 0) + " - error"]};

if (_counter == 1) then
{
	_filesystem deleteAt _fileToDeleteIndex;
	_consoleInput setVariable ["filesystem", _filesystem];
};

_result;