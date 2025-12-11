/*
 * Author: Root
 * Description: Handles the Rename dialog for the Zeus filesystem browser. On load, populates the dialog with the current item name.
 * On unload with OK, renames the selected file or folder to the new name. Validates that the new name doesn't already exist
 * and prevents renaming system directories.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The rename dialog display
 * 1: _exitCode <NUMBER> - Exit code from the display (1 = OK, other = Cancel)
 * 2: _mode <STRING> - Event mode ("onLoad" or "onUnload")
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 1, "onUnload"] call AE3_main_fnc_zeus_filesystemBrowser_rename;
 *
 * Public: No
 */

params ["_display", "_exitCode", "_mode"];

if (_mode isEqualTo "onLoad") then
{
	// Get the current file from the browser display and set it in the rename dialog
	private _browserDisplay = findDisplay 16993;
	if (isNull _browserDisplay) exitWith {};

	private _currentFile = _browserDisplay getVariable ["AE3_currentFile", ""];
	if (_currentFile isEqualTo "") exitWith {
		closeDialog 0;
		hint localize "STR_AE3_Main_Zeus_NoFileSelected";
	};

	// Set the current filename in the text field
	private _editCtrl = _display displayCtrl 1400;
	_editCtrl ctrlSetText _currentFile;
	_display setVariable ["newname", _currentFile];

	// Enable OK button since we have a valid name
	private _okCtrl = _display getVariable ["okCtrl", objNull];
	if (!isNull _okCtrl) then {
		_okCtrl ctrlEnable true;
	};
};

if (_mode isEqualTo "onUnload") exitWith
{
	if (_exitCode != 1) exitWith {}; // User cancelled

	private _browserDisplay = findDisplay 16993;
	if (isNull _browserDisplay) exitWith {};

	private _entity = _browserDisplay getVariable ["AE3_entity", objNull];
	if (isNull _entity) exitWith {};

	private _pointer = _browserDisplay getVariable ["AE3_pointer", []];
	private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];
	private _currentFile = _browserDisplay getVariable ["AE3_currentFile", ""];

	if (_currentFile isEqualTo "") exitWith {
		hint localize "STR_AE3_Main_Zeus_NoFileSelected";
	};

	// Check if trying to modify system folder
	private _pathString = "/" + (_pointer joinString "/");
	if (_pathString in ["/bin", "/sbin", "/etc"]) exitWith
	{
		hint localize "STR_AE3_Main_Zeus_CannotModifySystemFolder";
	};

	// Get new name from dialog
	private _newName = _display getVariable ["newname", ""];

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
		if (isNil "_itemObj") throw localize "STR_AE3_Main_Exception_FileNotFound";

		// Rename (copy to new name and delete old)
		_dirContent set [_newName, _itemObj];
		_dirContent deleteAt _currentFile;

		// Save filesystem
		_entity setVariable ["AE3_filesystem", _filesystem, true];

		// Clear current file and refresh
		_browserDisplay setVariable ["AE3_currentFile", ""];
		[_browserDisplay] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

		hint format [localize "STR_AE3_Main_Zeus_Renamed", _currentFile, _newName];
	}
	catch
	{
		hint format [localize "STR_AE3_Main_Zeus_RenameFailed", _exception];
	};
};
