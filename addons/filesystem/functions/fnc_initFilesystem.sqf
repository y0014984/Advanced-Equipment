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

private _filesystem = [createHashMapFromArray [], 'root', [[true, true, true], [true, true, false]]];

/* ================================================================================ */

private _config = configFile >> "AE3_FilesystemObjects";

private _filesystemObjects = ("inheritsFrom _x == (configFile >> 'AE3_FilesystemObject')" configClasses _config);

{
	private _ptr = [];

	try
	{
		private _type = getText (_x >> "type");
		private _path = getText (_x >> "path");
		private _owner = getText (_x >> "owner");
		// BIS_fnc_getCfgData seems to be preferred about getArray, see BI Wiki
		// Boolean in Config is not supported; You can use Numbers (1 or 0) or String ("true" or "false"); Then you need to convert them
		private _permissions = (_x >> "permissions") call BIS_fnc_getCfgData; // [[Number, Number, Number], [Number, Number, Number]]
		private _permissionsOwner = (_permissions select 0) apply { _x > 0 };
		private _permissionsOthers = (_permissions select 1) apply { _x > 0 };
		_permissions = [_permissionsOwner, _permissionsOthers]; // [[Bool, Bool, Bool], [Bool, Bool, Bool]]

		if (_type isEqualTo "File") then
		{
			[
				_ptr, 
				_filesystem, 
				_path, 
				(getText (_x >> "content")), 
				"root", 
				_owner,
				_permissions 
			] call AE3_filesystem_fnc_createFile;
		}
		else
		{
 			[
				_ptr,
				_filesystem,
				_path,
				"root",
				_owner, 
				_permissions
			] call AE3_filesystem_fnc_createDir;
		};
	}catch {};
} forEach _filesystemObjects;

/* ================================================================================ */

_entity setVariable ['AE3_filesystem', _filesystem, true];
_entity setVariable ['AE3_filepointer', [], true];