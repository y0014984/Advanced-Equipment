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

params['_pntr', '_filesystem', '_target', ['_user', '']];

private _dir = [_pntr, _filesystem, _target, _user] call AE3_filesystem_fnc_chdir;

[(_dir select 1), _user, 1] call AE3_filesystem_fnc_hasPermission;
_current = (_dir select 1) select 0;

_result = [];
{
	_y = _y select 0;
	if(typeName _y isEqualTo "HASHMAP") then 
	{
		_result pushBack (_x + "/");
	}else
	{
		_result pushBack _x;
	};
} forEach _current;

_result;
