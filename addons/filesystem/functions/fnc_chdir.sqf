/**
 * Change directory.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem object [<HASHMAP>, <STRING>]
 * 2: Raw path to target directory <STRING>
 * 3: Creates a directory if it is not found <BOOL> (Optional)
 *
 * Results:
 * 0: Absolute path to target dir <[STRING]>
 * 1: Target dir <HASHMAP>
 */

params['_pntr', '_filesystem', '_target', ['_create', false], ['_user', '']];

private _path = _target splitString "/";
private _pointer = +_pntr;

private ['_current'];

if (_target find "/" == 0) then
{
	_pointer = [];
	_current = _fileSystem;
}else
{
	_current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
};

if (count _path == 0) exitWith {[_pointer, _current]};

{
	_iteration = [_pointer, _current, _filesystem, _create, _user] call {
		params['_pointer', '_current', '_filesystem', '_create', '_user'];

		if (_x isEqualTo ".") exitWith
		{
			[_current, _pointer];
		};

		if (_x isEqualTo "..") exitWith
		{

			if (count _pointer != 0) then 
			{
				_pointer deleteAt (count _pointer - 1);
				_current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
			};
			[_current, _pointer];
		};
		
		if (_x isEqualTo "~") exitWith
		{
			// TODO: Get Current User
			
			_currentUser = "root";

			if(_currentUser isEqualTo "root") then
			{
				_pointer = ["root"];
			}else
			{
				_pointer = ["home", _currentUser];
			};

			[_current, _pointer];
		};

		if(!(_x in (_current select 0))) then 
		{
			if(!_create) throw (format ["'%1' not found in '%2'!", _x, "/" + (_pointer joinString "/")]); 

			(_current select 0) set [_x, [createHashMap, _user]];
		};

		if(typeName (((_current select 0) get _x) select 0) != "HASHMAP") throw (format ["'%1' is not a directory!", _x]);

		_current = (_current select 0) get _x;
		_pointer pushBack _x;
			
		[_current, _pointer];
	};
	_current = _iteration select 0;
	_pointer = _iteration select 1;

}forEach _path;


[_pointer, _current];