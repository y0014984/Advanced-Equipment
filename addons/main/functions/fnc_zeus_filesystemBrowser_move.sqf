/**
 * Moves the currently selected file/folder to a different directory.
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

	// Prompt for destination path
	private _destPath = "/";
	_destPath = call compile (format ["'%1'", _destPath call BIS_fnc_guiMessage]);

	if (_destPath isEqualTo "") exitWith {};

	try
	{
		// Parse destination path
		private _destPointer = [];
		if (_destPath != "/") then
		{
			_destPointer = _destPath splitString "/";
			_destPointer = _destPointer select {_x != ""};
		};

		// Get source directory content
		private _srcDirObj = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
		private _srcDirContent = _srcDirObj select 0;

		// Get destination directory content
		private _destDirObj = [_destPointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
		private _destDirContent = _destDirObj select 0;

		// Check if destination is a directory
		if (typeName _destDirContent != "HASHMAP") throw "Destination is not a directory";

		// Check if destination already has an item with this name
		if (_currentFile in _destDirContent) throw format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _currentFile];

		// Get the item object
		private _itemObj = _srcDirContent get _currentFile;
		if (isNil "_itemObj") throw "File not found";

		// Check if trying to move a directory into itself
		private _isDir = (typeName (_itemObj select 0)) isEqualTo "HASHMAP";
		if (_isDir) then
		{
			private _srcPath = _pointer joinString "/";
			private _destPathStr = _destPointer joinString "/";
			if (_destPathStr find _srcPath == 0) throw "Cannot move directory into itself";
		};

		// Move (copy to destination and delete from source)
		_destDirContent set [_currentFile, _itemObj];
		_srcDirContent deleteAt _currentFile;

		// Save filesystem
		_entity setVariable ["AE3_filesystem", _filesystem, true];

		// Clear current file and refresh
		_display setVariable ["AE3_currentFile", ""];
		[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

		hint format [localize "STR_AE3_Main_Zeus_Moved", _currentFile, _destPath];
	}
	catch
	{
		hint format [localize "STR_AE3_Main_Zeus_MoveFailed", _exception];
	};
};
