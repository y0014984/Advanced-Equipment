/*
 * Author: Root
 * Description: Handles the Move dialog for the Zeus filesystem browser. On load, populates a tree control with the directory
 * structure, excluding the item being moved and its subdirectories. On unload with OK, moves the selected file or folder
 * to the chosen destination. Prevents moving into subdirectories of the source and moving to system directories.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The move dialog display
 * 1: _exitCode <NUMBER> - Exit code from the display (1 = OK, other = Cancel)
 * 2: _mode <STRING> - Event mode ("onLoad" or "onUnload")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 1, "onUnload"] call AE3_main_fnc_zeus_filesystemBrowser_move;
 *
 * Public: No
 */

params ["_display", "_exitCode", "_mode"];

if (_mode isEqualTo "onLoad") then
{
	// Get the current file from the browser display
	private _browserDisplay = findDisplay 16993;
	if (isNull _browserDisplay) exitWith {};

	private _currentFile = _browserDisplay getVariable ["AE3_currentFile", ""];
	if (_currentFile isEqualTo "") exitWith {
		closeDialog 0;
		hint localize "STR_AE3_Main_Zeus_NoFileSelected";
	};

	private _entity = _browserDisplay getVariable ["AE3_entity", objNull];
	if (isNull _entity) exitWith { closeDialog 0; };

	private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];
	private _sourcePointer = _browserDisplay getVariable ["AE3_pointer", []];

	// Store info in display for later use
	_display setVariable ["AE3_sourcePointer", _sourcePointer];
	_display setVariable ["AE3_sourceFile", _currentFile];
	_display setVariable ["AE3_filesystem", _filesystem];

	// Get tree control and populate it
	private _treeCtrl = _display displayCtrl 1500;
	tvClear _treeCtrl;

	// Add root directory
	private _rootIndex = _treeCtrl tvAdd [[], "/"];
	_treeCtrl tvSetData [[_rootIndex], "/"];
	_treeCtrl tvSetColor [[_rootIndex], [0, 0.55, 0.97, 1]];

	// Get root content and populate recursively
	private _rootObj = [[], _filesystem] call AE3_filesystem_fnc_resolvePntr;
	private _rootContent = _rootObj select 0;

	// Populate tree starting from root
	[_treeCtrl, _rootContent, [], [_rootIndex], _sourcePointer, _currentFile] call AE3_main_fnc_zeus_filesystemBrowser_populateTree;

	// Expand root by default
	_treeCtrl tvExpand [_rootIndex];

	// Set up selection change handler to update path display
	_treeCtrl ctrlAddEventHandler ["TreeSelChanged", {
		params ["_control", "_selPath"];
		private _display = ctrlParent _control;
		private _pathData = _control tvData _selPath;

		// Update path display
		private _pathCtrl = _display displayCtrl 1400;
		_pathCtrl ctrlSetText _pathData;

		// Store selected path
		_display setVariable ["destpath", _pathData];
	}];

	// Select root by default
	_treeCtrl tvSetCurSel [_rootIndex];

	// Update path display
	private _pathCtrl = _display displayCtrl 1400;
	_pathCtrl ctrlSetText "/";
	_display setVariable ["destpath", "/"];
};

if (_mode isEqualTo "onUnload") exitWith
{
	if (_exitCode != 1) exitWith {}; // User cancelled

	private _browserDisplay = findDisplay 16993;
	if (isNull _browserDisplay) exitWith {};

	private _entity = _browserDisplay getVariable ["AE3_entity", objNull];
	if (isNull _entity) exitWith {};

	private _sourcePointer = _browserDisplay getVariable ["AE3_pointer", []];
	private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];
	private _currentFile = _browserDisplay getVariable ["AE3_currentFile", ""];

	if (_currentFile isEqualTo "") exitWith {
		hint localize "STR_AE3_Main_Zeus_NoFileSelected";
	};

	// Check if trying to modify system folder
	private _pathString = "/" + (_sourcePointer joinString "/");
	if (_pathString in ["/bin", "/sbin", "/etc"]) exitWith
	{
		hint localize "STR_AE3_Main_Zeus_CannotModifySystemFolder";
	};

	// Get destination path from dialog
	private _destPath = _display getVariable ["destpath", ""];

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
		private _srcDirObj = [_sourcePointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
		private _srcDirContent = _srcDirObj select 0;

		// Get destination directory content
		private _destDirObj = [_destPointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
		private _destDirContent = _destDirObj select 0;

		// Check if destination is a directory
		if (typeName _destDirContent != "HASHMAP") throw "Destination is not a directory";

		// Check if trying to move to the same directory
		if (_sourcePointer isEqualTo _destPointer) exitWith {
			hint localize "STR_AE3_Main_Zeus_AlreadyInThisDirectory";
		};

		// Check if destination already has an item with this name
		if (_currentFile in _destDirContent) throw format [localize "STR_AE3_Filesystem_Exception_AlreadyExists", _currentFile];

		// Get the item object
		private _itemObj = _srcDirContent get _currentFile;
		if (isNil "_itemObj") throw "File not found";

		// Check if trying to move a directory into itself or its subdirectory
		private _isDir = (typeName (_itemObj select 0)) isEqualTo "HASHMAP";
		if (_isDir) then
		{
			private _srcPath = _sourcePointer joinString "/";
			private _destPathStr = _destPointer joinString "/";
			// Check if destination path starts with source path
			if ((_destPathStr + "/") find (_srcPath + "/") == 0) throw "Cannot move directory into itself or its subdirectory";
		};

		// Move (copy to destination and delete from source)
		_destDirContent set [_currentFile, _itemObj];
		_srcDirContent deleteAt _currentFile;

		// Save filesystem
		_entity setVariable ["AE3_filesystem", _filesystem, true];

		// Clear current file and refresh
		_browserDisplay setVariable ["AE3_currentFile", ""];
		[_browserDisplay] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

		hint format [localize "STR_AE3_Main_Zeus_Moved", _currentFile, _destPath];
	}
	catch
	{
		hint format [localize "STR_AE3_Main_Zeus_MoveFailed", _exception];
	};
};
