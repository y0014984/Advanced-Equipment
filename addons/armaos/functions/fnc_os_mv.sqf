params ["_options", "_consoleInput"];

private _pointer = _consoleInput getVariable "AE3_filepointer";
private _filesystem = _consoleInput getVariable "AE3_filesystem";

if (count _options > 2) exitWith {["   Command: mv - too many options"];};

if (count _options < 2) exitWith {["   Command: rm - too few options"];};

_options params ['_oldPath', '_newPath'];

_result = ["   Command: mv " + _oldPath + " " + _newPath];

try
{
	[_pointer, _filesystem, _oldPath, _newPath] call AE3_filesystem_fnc_mvObj;
	
}catch
{
	_result pushBack _exception;
};
_result;
