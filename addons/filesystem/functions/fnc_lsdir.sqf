/**
 * List directory.
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem <HASHMAP>
 * 2: Raw path to target directory <STRING>
 * 3: User <STRING> (Optional)
 *
 * Results:
 * Content of the directory <[STRING]>
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

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_chdir;

[(_dir select 1), _user, 1] call AE3_filesystem_fnc_hasPermission;
_current = (_dir select 1) select 0;

_result = [];
{
	_buffer = "";

	if(_long) then
	{
		_buffer = format ["%1  %2  ", [_y] call _permissionString, _y select 1];
	};

	_buffer = _buffer + ([_x, _y, _user] call
	{
		params ['_name', '_object', '_user'];

		// If directory
		if(typeName (_object select 0) isEqualTo "HASHMAP") exitWith
		{
			format ["<t color='#008df8'>%1/</t>", _name];
		};

		// If executable
		try
		{
			[_object, _user, 0] call AE3_filesystem_fnc_hasPermission;
			format ["<t color='#8ce10b'>%1/</t>", _name];
		}catch
		{
			_name;
		}
	});

	_result pushBack _buffer;

} forEach _current;

_result;
