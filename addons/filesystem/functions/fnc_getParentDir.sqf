/*
 * Author: Root
 * Description: Resolves the parent directory of a given path and returns the parent directory object along with the target name. Handles special paths like . .. and ~. Can optionally create parent directories if they don't exist.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to target (file or directory)
 * 3: _user <STRING> (Optional, default: "") - User performing the operation
 * 4: _create <BOOL> (Optional, default: false) - Create parent directories if they don't exist
 * 5: _owner <STRING> (Optional, default: _user) - Owner of created directories
 * 6: _permissions <ARRAY> (Optional, default: [[true,true,true],[false,false,false]]) - Permissions for created directories
 *
 * Return Value:
 * Array containing parent directory information <ARRAY>
 * 0: Absolute path to parent directory <ARRAY>
 * 1: Parent directory object <ARRAY>
 * 2: Target name (filename or directory name) <STRING>
 *
 * Example:
 * [[], _filesystem, "/tmp/test.txt", "root"] call AE3_filesystem_fnc_getParentDir;
 * [_pointer, _filesystem, "../newdir", "user", true] call AE3_filesystem_fnc_getParentDir;
 *
 * Public: No
 */

params['_pntr', '_filesystem', '_target', ['_user', ''], ['_create', false], ['_owner', nil], ['_permissions', [[true, true, true], [false, false, false]]]];

// Validate _target is a string
if (!(_target isEqualType "")) then {
	throw (format ["Error: Invalid path type. Expected string, got %1", typeName _target]);
};

private _path = _target splitString "/";
private _new = _path select -1;

if (_new isEqualTo "~") exitWith
{
	if(_user isEqualTo "root") then
	{
		_current = _filesystem;
		_pointer = [];
		_new = "root";
		[_pointer, _current, _new];
	}else
	{
		_current = (_filesystem select 0) get 'home';
		_pointer = ["home"];
		_new = "";
		if (_user isNotEqualTo '') then
		{
			_new = _user;
		};
		[_pointer, _current, _new];
	};
};

if ((_new isEqualTo "." && count _pntr == 0) || (_new isEqualTo ".." && count _pntr == 1)) exitWith
{
	[[], [createHashMapFromArray [[".", _filesystem]], 'root', [[true, true, true], [true, true, false]]], "."];
};

if (_new isEqualTo ".." && count _pntr == 0) throw (format [localize "STR_AE3_Filesystem_Exception_NotFound", ".."]);

_path = (_path select [0, count _path - 1]) joinString "/";

if (_target find "/" == 0) then
{
	_path = "/" + _path;
};

if (isNil "_owner") then 
{
	_owner = _user;
};

if (_new isEqualTo ".") then 
{
	_new = _pntr select -1;
	_path = ".."
};

if (_new isEqualTo "..") then 
{
	_new = _pntr select -2;
	_path = "../.."
};

private _result = [_pntr, _filesystem, _path, _user, _create, _owner, _permissions] call AE3_filesystem_fnc_chdir; // [_pointer, _current]
_result pushBack _new;

_result;
