/**
 * Initilizes the filesystem and loads filesystem objects from config.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Config <CONFIG> (Optional)
 *
 * Results:
 * None
 */

params["_entity", "_config"];

if(!isServer) exitWith {};

private _filesystem = [createHashMapFromArray [], 'root', [[true, true, true], [true, true, false]]];

/* ================================================================================ */

//private _config = configFile >> "AE3_FilesystemObjects";
if (!isNil "_config") then
{
	private _filesystemObjects = ("inheritsFrom _x == (configFile >> 'AE3_FilesystemObject')" configClasses _config);

	{
		private _ptr = [];

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
			// throws exception if file already exists
			try 
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
			catch
			{
				private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
				if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
				{
					diag_log format ["AE3 exception: %1", _exception];
				}
				else
				{
					throw _exception;
				};
			};
		}
		else
		{
			// throws exception if directory already exists
			try 
			{
				[
					_ptr,
					_filesystem,
					_path,
					"root",
					_owner, 
					_permissions
				] call AE3_filesystem_fnc_createDir;
			} 
			catch
			{
				private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
				if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
				{
					diag_log format ["AE3 exception: %1", _exception];
				}
				else
				{
					throw _exception;
				};
			};
		};
	} forEach _filesystemObjects;
};

_entity setVariable ["AE3_filesystem", _filesystem];
_entity setVariable ["AE3_filepointer", []];
