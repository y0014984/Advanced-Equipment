/**
 * Searches for a file in a given directory. 
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 4: User <STRING>
 * 2: Filesystem Object Name aka Search String <STRING>
 *
 * Results:
 * 0: Paths to Filesystem Objects <[STRING]>
 */

params ["_pointer", "_filesystem", "_user", "_filesystemObjectName"];

/*

	HASHMAP-ELEMENT = FILESYSTEM OBJECT
		KEY = STRING = NAME OF FILE/FOLDER
		VALUE = ARRAY [CONTENT, OWNER, PERMISSION]

	CONTENT
		HASHMAP
		STRING
		{CODE}

	ARRAY = ROOT FILESYSTEM FOLDER --> 
	[
		HASHMAP = Filesystem Folder Content = Multiple Filesystem Objects
		[
			HASHMAP-ELEMENT [NAME = KEY, ARRAY = VALUE]
			HASHMAP-ELEMENT [NAME = KEY, ARRAY = VALUE]
			HASHMAP-ELEMENT [NAME = KEY, ARRAY = VALUE]
		]
		OWNER
		PERMISSION
	]

*/

private _content = _filesystem select 0; // HASHMAP
private _owner = _filesystem select 1; // STRING
private _permissions = _filesystem select 2; // ARRAY

private _results = [];

/* if ([_fileObject, _user, _permission = 1]) then
{

}; */

{
	// Hashmap forEach variables: KEY = _x && VALUE = _y

	if (_filesystemObjectName isEqualTo _x) then
	{
		private _path = "/" + (_pointer joinString "/") + "/" + _filesystemObjectName;
		_results pushBack _path;
	};
	
	if ((typeName (_y select 0)) isEqualTo "HASHMAP") then
	{
		private _currentPointer = +_pointer;
		_currentPointer pushBack _x;

		private _subResults = [_currentPointer, _y, _user, _filesystemObjectName] call AE3_filesystem_fnc_findFileByName;
		_results append _subResults;
	};
} forEach _content;


_results;

// TODOS:
// - check permissions
// - allow searching for substrings
// - allow searching for file contents?
// - change name to findFilesystemObjectByName