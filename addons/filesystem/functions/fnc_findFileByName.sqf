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

private _results = [];

_filesystem = _filesystem select 0;

{
	//Hashmap key = _x ; value = _y

	if (_filename in _x) then { _results pushback _x; };

	if (typeName _y isEqualTo "HASHMAP") then
	{
		//_results pushBack [_pointer, _y, _user, _filename] call AE3_filesystem_fnc_findFileByName;
	};
} forEach _filesystem;

_results;