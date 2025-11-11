/*
 * Author: Root
 * Description: Handles double-click events on items in the Zeus filesystem browser. For directories, navigates into the directory.
 * For files, loads the file content and properties into the editor area for viewing/editing. Supports navigation to parent
 * directory via the ".." entry.
 *
 * Arguments:
 * 0: _control <CONTROL> - The list control that was double-clicked
 * 1: _selectedIndex <NUMBER> - The index of the selected item in the list
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control, 2] call AE3_main_fnc_zeus_filesystemBrowser_onDblClick;
 *
 * Public: No
 */

params ["_control", "_selectedIndex"];

private _display = ctrlParent _control;
private _entity = _display getVariable ["AE3_entity", objNull];
if (isNull _entity) exitWith {};

private _pointer = _display getVariable ["AE3_pointer", []];
private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];

private _itemName = _control lbData _selectedIndex;

// Handle parent directory
if (_itemName isEqualTo "..") exitWith
{
	if (count _pointer > 0) then
	{
		_pointer deleteAt ((count _pointer) - 1);
		_display setVariable ["AE3_pointer", _pointer];
		[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;
	};
};

// Get item object
private _dirObj = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
private _dirContent = _dirObj select 0;
private _itemObj = _dirContent get _itemName;

if (isNil "_itemObj") exitWith {};

private _isDir = (typeName (_itemObj select 0)) isEqualTo "HASHMAP";

if (_isDir) then
{
	// Navigate into directory
	_pointer pushBack _itemName;
	_display setVariable ["AE3_pointer", _pointer];
	[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;
}
else
{
	// Load file content for editing
	private _fileContent = _itemObj select 0;
	private _fileOwner = _itemObj select 1;
	private _filePerms = _itemObj select 2;

	// Update UI
	private _contentCtrl = _display displayCtrl 1401;
	_contentCtrl ctrlSetText (str _fileContent);

	private _ownerCtrl = _display displayCtrl 1402;
	_ownerCtrl ctrlSetText _fileOwner;

	// Set permission checkboxes
	private _ownerPerms = _filePerms select 0;
	private _everyonePerms = _filePerms select 1;

	(_display displayCtrl 1310) cbSetChecked (_ownerPerms select 1); // Owner Read
	(_display displayCtrl 1311) cbSetChecked (_ownerPerms select 2); // Owner Write
	(_display displayCtrl 1312) cbSetChecked (_ownerPerms select 0); // Owner Execute

	(_display displayCtrl 1313) cbSetChecked (_everyonePerms select 1); // Everyone Read
	(_display displayCtrl 1314) cbSetChecked (_everyonePerms select 2); // Everyone Write
	(_display displayCtrl 1315) cbSetChecked (_everyonePerms select 0); // Everyone Execute

	// Store current file for saving
	_display setVariable ["AE3_currentFile", _itemName];
	_display setVariable ["AE3_currentFilePerms", _filePerms];
};
