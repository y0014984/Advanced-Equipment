/**
 * List directory.
 *
 * Arguments:
 * 1: Pointer <[STRING]>
 * 2: Filesystem <HASHMAP>
 * 3: Raw path to target directory <STRING>
 *
 * Results:
 * Content of the directory <[STRING]>
 */

params['_pntr', '_filesystem', '_target'];

private _dir = [_pntr, _filesystem, _target] call AE3_filesystem_fnc_chdir;

if(_dir isEqualType []) exitWith 
{
	_dir params ['_pntr', '_current'];

	_result = [];
	{
		if(typeName _y isEqualTo "HASHMAP") then 
		{
			_result pushBack (_x + "/");
		}else
		{
			_result pushBack _x;
		};
	} forEach _current;

	_result
};

_dir;