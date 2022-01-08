/**
 * Change directory.
 *
 * Arguments:
 * 1: Pointer <[STRING]>
 * 2: Filesystem <HASHMAP>
 * 3: Raw path to target directory <STRING>
 * 4: Creates a directory if it is not found <BOOL> (Optional)
 *
 * Results:
 * 0: Absolute path to target dir <[STRING]>
 * 1: Target dir <HASHMAP>
 */

params['_pntr', '_filesystem', '_target', ['_create', false]];

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

private _result = {
	_iteration = [_pointer, _current, _filesystem, _create] call {
		params['_pointer', '_current', '_filesystem', '_create'];

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

		if(!(_x in _current)) then 
		{
			if(!_create) throw (format ["'%1' not found in '%2'!", _x, "/" + (_pointer joinString "/")]); 

			_current set [_x, createHashMap];
		};

		if(typeName (_current get _x) != "HASHMAP") throw (format ["'%1' is not a directory!", _x]);

		_current = _current get _x;
		_pointer pushBack _x;
			
		[_current, _pointer];
	};
	_current = _iteration select 0;
	_pointer = _iteration select 1;

}forEach _path;


[_pointer, _current];