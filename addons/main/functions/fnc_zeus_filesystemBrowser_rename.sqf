/**
 * Renames the currently selected file/folder.
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
	private _currentFile = _display getVariable ["AE3_currentFile", ""];

	if (_currentFile isEqualTo "") exitWith {
		hint localize "STR_AE3_Main_Zeus_NoFileSelected";
	};

	// Check if trying to modify system folder
	private _pathString = "/" + (_pointer joinString "/");
	if (_pathString in ["/bin", "/sbin", "/etc"]) exitWith
	{
		hint localize "STR_AE3_Main_Zeus_CannotModifySystemFolder";
	};

	// Prompt for new name
	private _newName = _currentFile;
	_newName = call compile (format ["'%1'", _newName call BIS_fnc_guiMessage]);

	if (_newName isEqualTo "") exitWith {};
	if (_newName isEqualTo _currentFile) exitWith {};

	try
	{
		// Get current directory content
		private _dirObj = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
		private _dirContent = _dirObj select 0;

		// Check if new name already exists
		if (_newName in _dirContent) throw format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _newName];

		// Get the item object
		private _itemObj = _dirContent get _currentFile;
		if (isNil "_itemObj") throw "File not found";

		// Rename (copy to new name and delete old)
		_dirContent set [_newName, _itemObj];
		_dirContent deleteAt _currentFile;

		// Save filesystem
		_entity setVariable ["AE3_filesystem", _filesystem, true];

		// Clear current file and refresh
		_display setVariable ["AE3_currentFile", ""];
		[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

		hint format [localize "STR_AE3_Main_Zeus_Renamed", _currentFile, _newName];
	}
	catch
	{
		hint format [localize "STR_AE3_Main_Zeus_RenameFailed", _exception];
	};
};
