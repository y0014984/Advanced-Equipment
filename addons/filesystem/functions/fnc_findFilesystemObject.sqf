/**
 * Searches for a filesystem object in a given directory. 
 *
 * Arguments:
 * 0: Pointer <[STRING]>
 * 1: Filesystem [<HASHMAP>, <STRING>]
 * 2: User <STRING>
 * 3: Filesystem Object Name aka Search String <STRING>
 * 4: Missing Permissions Count <NUMBER> (Optional) Only internally used for recursion
 *
 * Results:
 * 0: Paths to Filesystem Objects <[STRING]>
 */

params ["_pointer", "_filesystem", "_user", "_filesystemObjectName", ["_missingPermissions", 0]];

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

private _totalResults = [];

private _permissionNeeded = 1; // (0: Execute, 1: Read, 2: Write)

try
{
	// function does not return a bool but throws an exception if permissions insufficient
	[_filesystem, _user, _permissionNeeded] call AE3_filesystem_fnc_hasPermission;

	{
		// Hashmap forEach variables: KEY = _x && VALUE = _y

		if (_filesystemObjectName isEqualTo _x) then
		{
			private _path = "/" + (_pointer joinString "/");
			// to prevent double /-sign if we are in root folder
			if (!(_path isEqualTo "/")) then { _path = _path + "/"; };
			_path = _path + _filesystemObjectName;
			_totalResults pushBack _path;
		};
		
		if ((typeName (_y select 0)) isEqualTo "HASHMAP") then
		{
			private _currentPointer = +_pointer;
			_currentPointer pushBack _x;

			private _result = [_currentPointer, _y, _user, _filesystemObjectName, _missingPermissions] call AE3_filesystem_fnc_findFilesystemObject;

			private _subResults = _result select 0;
			_missingPermissions = _result select 1;

			_totalResults append _subResults;
		};
	} forEach _content;

} catch { _missingPermissions = _missingPermissions + 1; };

[_totalResults, _missingPermissions];