/**
 * Initilizes the filesystem and loads filesystem objects from config.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Results:
 * None
 */

params["_entity"];

if(!isServer) exitWith {};

private _filesystem = [createHashMapFromArray
	[
		// Essential user commands
		["bin", [createHashMap, 'root', [[true, true, true], [true, true, false]]]],

		// Essential system commands
		["sbin", [createHashMap, 'root', [[true, true, true], [true, true, false]]]],

		// User home dirs.
		["home", [createHashMap, 'root', [[true, true, true], [true, true, false]]]],

		// Root home dir
		["root", [createHashMap, 'root', [[true, true, true], [false, false, false]]]],

		// Mount file for tmp filesystems
		["mnt", [createHashMap, 'root', [[true, true, true], [true, true, false]]]],

		// temporaray files saved between reboots
		["tmp", [createHashMap, 'root', [[true, true, true], [true, true, true]]]],

		// ???
		["var", [createHashMap, 'root', [[true, true, true], [true, true, false]]]]
	], 'root', [[true, true, true], [true, true, false]]];

/* ================================================================================ */

private _config = configFile >> "AE3_FilesystemObjects";

private _filesystemObjects = ("inheritsFrom _x == (configFile >> 'AE3_FilesystemObject')" configClasses _config);

{
	try
	{
		private _type = getText (_x >> "type");

		if (_type isEqualTo "File") then
		{
			// BIS_fnc_getCfgData seems to be preferred about getArray, see BI Wiki
			// Boolean in Config is not supported; You can use Numbers (1 or 0) or String ("true" or "false"); Then you need to convert them
			private _permissions = (_x >> "permissions") call BIS_fnc_getCfgData; // [[Number, Number, Number], [Number, Number, Number]]
			private _permissionsOwner = (_permissions select 0) apply { _x > 0 };
			private _permissionsOthers = (_permissions select 1) apply { _x > 0 };
			_permissions = [_permissionsOwner, _permissionsOthers]; // [[Bool, Bool, Bool], [Bool, Bool, Bool]]

			[
				[], 
				_filesystem, 
				(getText (_x >> "path")), 
				(getText (_x >> "content")), 
				"root", 
				(getText (_x >> "owner")),
				_permissions 
			] call AE3_filesystem_fnc_createFile;
		};
	}catch {};
} forEach _filesystemObjects;

/* ================================================================================ */

_entity setVariable ['AE3_filesystem', _filesystem, true];
_entity setVariable ['AE3_filepointer', [], true];