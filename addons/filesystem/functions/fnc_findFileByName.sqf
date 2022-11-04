/**
 * Searches for a file in a given directory. 
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 4: User <STRING>
 * 2: Filename <STRING>
 *
 * Results:
 * 0: Filenames <[STRING]>
 */

params ["_pointer", "_filesystem", "_user", "_filename"];

private _current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;

_filesystem = _current;

private _results = [];

private _content = _filesystem select 0; // HASHMAP or STRING or SCRIPT
private _owner = _filesystem select 1; // STRING
private _permissions = _filesystem select 2; // ARRAY

if ((typeName _content) isEqualTo "HASHMAP") then
{
	{
		//Hashmap key = _x ; value = _y

		private _tmpPointer = +_pointer;
		_tmpPointer pushBack _x;
		private _path = "/" + (_tmpPointer joinString "/");
		if (_filename isEqualTo _x) then { _results pushBack _path; };

		if ((typeName _content) isEqualTo "HASHMAP") then
		{
			private _subResults = [_tmpPointer, _filesystem, _user, _filename] call AE3_filesystem_fnc_findFileByName;
			_results append _subResults;
		};
	} forEach _content;
};

_results;

// TODOS:
// - check permissions
// - allow searching for substrings
// - allow searching for file contents?
// - change name to findFilesystemObjectByName