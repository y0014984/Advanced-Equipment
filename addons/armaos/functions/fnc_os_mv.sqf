params ["_options", "_consoleInput"];

_pointer = _consoleInput getVariable "pointer";
_filesystem = _consoleInput getVariable "filesystem";

_oldPath = "";
_newPath = "";

_result = [];

_optionsCount = count _options;

scopeName "main";

switch (true) do
{
	case (_optionsCount > 2):
	{
		_result = ["   Command: mv - too many options"];
		_result breakOut "main";
	};
	case (_optionsCount <= 1):
	{
		_result = ["   Command: rm - too few options"];
		_result breakOut "main";
	};
	case (_optionsCount == 2):
	{
		_optionsString = _options select 0;
		
		if ((_optionsString select [0, 1]) isEqualTo "/") then
		{
			_oldPath = _optionsString;
		}
		else
		{
			_oldPath = _pointer + _optionsString;
		};

		_optionsString = _options select 1;
		
		if ((_optionsString select [0, 1]) isEqualTo "/") then
		{
			_newPath = _optionsString;
		}
		else
		{
			_newPath = _pointer + _optionsString;
		};
	};
};

_result = ["   Command: mv " + _oldPath + " " + _newPath];

_counterOldPath = 0;
_counterNewPath = 0;
_fileToMoveIndex = -1;

{
	_file = _x select 0;
	if ((_file find _oldPath) == 0) then
	{
		_counterOldPath = _counterOldPath + 1;
		_fileToMoveIndex = _forEachIndex;
	};

	if ((_file find _newPath) == 0) then
	{
		_counterNewPath = _counterNewPath + 1;
	};
} forEach _filesystem;

if (_counterOldPath == 0) then {_result = [(_result select 0) + " - file not found"]};
if (_counterNewPath > 0) then {_result = [(_result select 0) + " - file already exists"]};

// Multiple Files with the same path in Filesystem or Path == Folder with multiple Files
if ((_counterOldPath > 1) or (_counterNewPath > 1)) then {_result = [(_result select 0) + " - error"]};

if ((_counterOldPath == 1) && (_counterNewPath == 0)) then
{
	_content = (_filesystem select _fileToMoveIndex) select 1;
	_newFilesystemObject = [_newPath, _content];
	_filesystem set [_fileToMoveIndex, _newFilesystemObject];
	_consoleInput setVariable ["filesystem", _filesystem];
};

_result;