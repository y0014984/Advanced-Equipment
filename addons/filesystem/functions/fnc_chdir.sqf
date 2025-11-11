/*
 * Author: Root
 * Description: Changes the current working directory to the specified path. Resolves relative paths (.., ., ~) and can optionally create directories if they don't exist.
 *
 * Arguments:
 * 0: _pntr <ARRAY> - Current directory pointer (array of directory names)
 * 1: _filesystem <ARRAY> - Filesystem object [HASHMAP, STRING, ARRAY]
 * 2: _target <STRING> - Path to target directory (absolute or relative)
 * 3: _user <STRING> (Optional, default: "") - User performing the operation
 * 4: _create <BOOL> (Optional, default: false) - Create directory if it doesn't exist
 * 5: _owner <STRING> (Optional, default: _user) - Owner of created directory
 * 6: _permissions <ARRAY> (Optional, default: [[true,true,true],[false,false,false]]) - Permissions [[owner x,r,w],[everyone x,r,w]]
 *
 * Return Value:
 * Array of [pointer, directory object] <ARRAY>
 * 0: Absolute path to target directory <ARRAY>
 * 1: Target directory object <ARRAY>
 *
 * Example:
 * [[], _filesystem, "/home/user", "root"] call AE3_filesystem_fnc_chdir;
 * [_pointer, _filesystem, "../etc", "user"] call AE3_filesystem_fnc_chdir;
 * [[], _filesystem, "~/documents", "user", true] call AE3_filesystem_fnc_chdir;
 *
 * Public: No
 */

params['_pntr', '_filesystem', '_target', ['_user', ''], ['_create', false], ['_owner', nil], ['_permissions', [[true, true, true], [false, false, false]]]];

private _path = _target splitString "/";
private _pointer = +_pntr;

private ['_current'];

if (isNil "_owner") then 
{
	_owner = _user;
};

if (_target find "/" == 0) then
{
	_pointer = [];
	_current = _fileSystem;
}else
{
	try
	{
		_current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
	} catch
	{
		// Allows for paths getting out of invalid dirs
		if (count _path == 0) throw _exception;
		if ((_path select 0) != ".." && (_path select 0) != "~") throw _exception;
		_current = createHashMap;
	}
	
};

if (_path isEqualTo []) exitWith {[_pointer, _current]};
{
	_iteration = [_pointer, _current, _filesystem, _create, _user, _owner, _permissions, _path] call
	{
		params['_pointer', '_current', '_filesystem', '_create', '_user', '_owner', '_permissions', '_path'];

		if (_x isEqualTo ".") exitWith
		{
			[_current, _pointer];
		};

		if (_x isEqualTo "..") exitWith
		{

			if (count _pointer != 0) then 
			{
				_pointer deleteAt (count _pointer - 1);
				try
				{
					_current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
				} catch
				{
					// Allows for paths getting out of invalid dirs
					if (count _path - _forEachIndex - 1 == 0) throw _exception;
					if ((_path select (_forEachIndex + 1)) != ".." && (_path select (_forEachIndex + 1)) != "~") throw _exception;
					_current = createHashMap;
				}
			};
			[_current, _pointer];
		};
		
		if (_x isEqualTo "~") exitWith
		{
			if(_user isEqualTo "root") then
			{
				_current = (_filesystem select 0) get 'root';
				_pointer = ["root"];
			}else
			{
				_current = (_filesystem select 0) get 'home';
				_pointer = ["home"];

				if(_user isNotEqualTo '') then
				{
					_current = (_current select 0) get _user;
					_pointer pushBack _user;
				};
			};

			[_current, _pointer];
		};

		if(!(_x in (_current select 0))) then 
		{
			if(!_create) throw (format [localize "STR_AE3_Filesystem_Exception_NotFoundInDir", _x, "/" + (_pointer joinString "/")]); 

			(_current select 0) set [_x, [createHashMap, _owner, _permissions]];
		};

		if(typeName (((_current select 0) get _x) select 0) != "HASHMAP") throw (format [localize "STR_AE3_Filesystem_Exception_IsNotADir", _x]);

		_current = (_current select 0) get _x;
		_pointer pushBack _x;
			
		[_current, _pointer];
	};

	_current = _iteration select 0;
	_pointer = _iteration select 1;

}forEach _path;

[_pointer, _current];
