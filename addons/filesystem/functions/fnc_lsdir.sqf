/*
 * Author: Root, Wasserstoff
 * Description: Lists the contents of a directory. Returns formatted output with optional detailed information including permissions and ownership. Directories are displayed in blue, executables in green.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer
 * 1: _filesystem <ARRAY> - Filesystem object
 * 2: _target <STRING> - Path to directory to list
 * 3: _user <STRING> (Optional, default: "") - User performing the operation
 * 4: _long <BOOL> (Optional, default: false) - Show detailed listing with permissions and owner
 *
 * Return Value:
 * Array of directory entries (each entry is array of [permission string, name with color]) <ARRAY>
 *
 * Example:
 * [[], _filesystem, "/tmp", "root"] call AE3_filesystem_fnc_lsdir;
 * [[], _filesystem, "/home/user", "user", true] call AE3_filesystem_fnc_lsdir;
 *
 * Public: Yes
 */

params['_pntr', '_filesystem', '_target', ['_user', ''], ['_long', false]];

private _permissionString = 
{
	params['_object'];

	private _result = "";
	if(typeName (_object select 0) isEqualTo "HASHMAP") then
	{
		_result = _result + "d"
	}else
	{
		_result = _result + "-"
	};

	{
		if(_x select 1) then {_result = _result + "r"} else {_result = _result + "-"};
		if(_x select 2) then {_result = _result + "w"} else {_result = _result + "-"};
		if(_x select 0) then {_result = _result + "x"} else {_result = _result + "-"};
	}forEach (_object select 2);

	_result;
};

private _ownerString =
{
	params['_object', '_length'];

	private _result = _object select 1;

	for [{private _i = 0}, {count _result < _length}, {_i = _i + 1}] do
	{
		_result = _result + " ";
	};

	_result;
};

// Get directory
private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_chdir;

// Check permissions
[(_dir select 1), _user, 1] call AE3_filesystem_fnc_hasPermission;
_folder = (_dir select 1) select 0;
_files = keys _folder;
_files sort true;

// Get max owner name length for align
private _maxOwnerLength = 5;
if(_long) then
{
	{
		_y = _folder  get _x;
		if(count (_y select 1) > _maxOwnerLength) then
		{
			_maxOwnerLength = count (_y select 1);
		};

	}forEach _files;
};

_result = [];
{
	_buffer = [];
	_y = _folder  get _x;

	if(_long) then
	{
		_buffer = [format ["%1  %2  ", [_y] call _permissionString, [_y, _maxOwnerLength] call _ownerString]];
	};

	_buffer pushBack ([_x, _y, _user] call
	{
		params ['_name', '_object', '_user'];

		// If directory
		if(typeName (_object select 0) isEqualTo "HASHMAP") exitWith
		{
			[_name, "#008df8"];
		};

		// If executable
		try
		{
			[_object, _user, 0] call AE3_filesystem_fnc_hasPermission;
			[_name, "#8ce10b"];
		}catch
		{
			[_name];
		}
	});

	_result pushBack _buffer;

} forEach _files;

_result;
