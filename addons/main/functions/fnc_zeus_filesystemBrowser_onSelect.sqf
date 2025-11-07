/**
 * Handles selection change on filesystem browser list item.
 * Sets the selected item (file or folder) as current for operations like move/rename/delete.
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

// Clear selection if parent directory or invalid item selected
if (_itemName isEqualTo ".." || _itemName isEqualTo "") exitWith {
	_display setVariable ["AE3_currentFile", ""];

	// Clear file content and properties display
	private _contentCtrl = _display displayCtrl 1401;
	_contentCtrl ctrlSetText "";

	private _ownerCtrl = _display displayCtrl 1402;
	_ownerCtrl ctrlSetText "";

	private _permCtrl = _display displayCtrl 1403;
	_permCtrl ctrlSetText "";
};

// Get item object
private _dirObj = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
private _dirContent = _dirObj select 0;
private _itemObj = _dirContent get _itemName;

if (isNil "_itemObj") exitWith {
	_display setVariable ["AE3_currentFile", ""];
};

// Store current selection
_display setVariable ["AE3_currentFile", _itemName];

private _isDir = (typeName (_itemObj select 0)) isEqualTo "HASHMAP";

if (_isDir) then
{
	// For directories, just store the selection but don't load properties
	// Clear file content and properties display
	private _contentCtrl = _display displayCtrl 1401;
	_contentCtrl ctrlSetText "";

	private _ownerCtrl = _display displayCtrl 1402;
	_ownerCtrl ctrlSetText "";

	private _permCtrl = _display displayCtrl 1403;
	_permCtrl ctrlSetText "";
}
else
{
	// For files, load content and properties
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

	// Store current file permissions for saving
	_display setVariable ["AE3_currentFilePerms", _filePerms];
};
