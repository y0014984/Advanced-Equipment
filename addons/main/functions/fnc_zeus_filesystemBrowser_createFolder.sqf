/**
 * Creates a new folder in the current directory.
 *
 * Arguments:
 * None
 *
 * Results:
 * None
 */

[] spawn {
	private _display = findDisplay 16993;
	if (isNull _display) exitWith {};

	private _entity = _display getVariable ["AE3_entity", objNull];
	if (isNull _entity) exitWith {};

	private _pointer = _display getVariable ["AE3_pointer", []];
	private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];

	// Check if trying to modify system folder
	private _pathString = "/" + (_pointer joinString "/");
	if (_pathString in ["/bin", "/sbin", "/etc"]) exitWith
	{
		hint localize "STR_AE3_Main_Zeus_CannotModifySystemFolder";
	};

	// Prompt for folder name
	private _foldername = "newfolder";
	_foldername = call compile (format ["'%1'", _foldername call BIS_fnc_guiMessage]);

	if (_foldername isEqualTo "") exitWith {};

	// Create folder
	try
	{
		[_pointer, _filesystem, _foldername, "root", "root"] call AE3_filesystem_fnc_createDir;
		_entity setVariable ["AE3_filesystem", _filesystem, true];

		[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

		hint format [localize "STR_AE3_Main_Zeus_FolderCreated", _foldername];
	}
	catch
	{
		hint format [localize "STR_AE3_Main_Zeus_FolderCreationFailed", _exception];
	};
};
