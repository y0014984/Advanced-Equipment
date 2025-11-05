/**
 * Get parent dir.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Raw path to target directory <STRING>
 * 3: User <STRING> (Optional)
 * 4: Creates a directory if it is not found <BOOL> (Optional)
 * 5: Owner of the created directory <String> (Optional)
 * 6: Permissions of the created directory [[<BOOL>]] (Optional)
 *
 * Results:
 * 0: Absolute path to target dir <[STRING]>
 * 1: Target dir <HASHMAP>
 * 2: Tail <STRING>
 */

params['_pntr', '_filesystem', '_target', ['_user', ''], ['_create', false], ['_owner', nil], ['_permissions', [[true, true, true], [false, false, false]]]];

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
