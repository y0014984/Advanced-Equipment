/*
 * Author: Root
 * Description: Deletes the currently selected file or folder in the Zeus filesystem browser. Validates that the item is not a
 * protected system directory or file (/bin, /sbin, /etc). Uses root privileges for deletion. Refreshes the display after
 * successful deletion.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_filesystemBrowser_delete;
 *
 * Public: No
 */

private _display = findDisplay 16993;
if (isNull _display) exitWith {};

private _entity = _display getVariable ["AE3_entity", objNull];
if (isNull _entity) exitWith {};

private _listCtrl = _display displayCtrl 1500;
private _selectedIndex = lbCurSel _listCtrl;

if (_selectedIndex < 0) exitWith
{
	hint localize "STR_AE3_Main_Zeus_NoItemSelected";
};

private _itemName = _listCtrl lbData _selectedIndex;
if (_itemName isEqualTo ".." || _itemName isEqualTo "") exitWith {};

private _pointer = _display getVariable ["AE3_pointer", []];
private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];

// Check if trying to delete system files/folders
private _fullPath = _pointer + [_itemName];
private _pathString = "/" + (_fullPath joinString "/");

private _systemPaths = ["/bin", "/sbin", "/etc"];
{
	if (_pathString find _x == 0) exitWith
	{
		hint localize "STR_AE3_Main_Zeus_CannotDeleteSystemItem";
		_itemName = "";
	};
} forEach _systemPaths;

if (_itemName isEqualTo "") exitWith {};

// Delete the item (Zeus has root privileges)
try
{
	[_pointer, _filesystem, _itemName, 'root'] call AE3_filesystem_fnc_delObj;
	_entity setVariable ["AE3_filesystem", _filesystem, true];

	[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

	hint format [localize "STR_AE3_Main_Zeus_ItemDeleted", _itemName];
}
catch
{
	hint format [localize "STR_AE3_Main_Zeus_ItemDeletionFailed", _exception];
};
