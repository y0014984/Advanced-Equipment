/**
 * Handles double-click on filesystem browser list item.
 *
 * Arguments:
 * 0: Control <CONTROL>
 * 1: Selected Index <NUMBER>
 *
 * Results:
 * None
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

	// Format permissions string
	private _permString = "";
	{
		_permString = _permString + (["-", "x"] select (_x select 0));
		_permString = _permString + (["-", "r"] select (_x select 1));
		_permString = _permString + (["-", "w"] select (_x select 2));
		if (_forEachIndex == 0) then { _permString = _permString + " / " };
	} forEach _filePerms;

	// Update UI
	private _contentCtrl = _display displayCtrl 1401;
	_contentCtrl ctrlSetText _fileContent;

	private _ownerCtrl = _display displayCtrl 1402;
	_ownerCtrl ctrlSetText _fileOwner;

	private _permCtrl = _display displayCtrl 1403;
	_permCtrl ctrlSetText _permString;

	// Store current file for saving
	_display setVariable ["AE3_currentFile", _itemName];
};
