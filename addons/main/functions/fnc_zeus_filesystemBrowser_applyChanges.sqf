/*
 * Author: Root
 * Description: Applies owner and permission changes to the currently selected file or folder in the Zeus filesystem browser.
 * Reads the modified owner name and permission checkboxes from the UI, updates the filesystem object, saves the changes,
 * and refreshes the display.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_filesystemBrowser_applyChanges;
 *
 * Public: No
 */

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

try
{
	// Get current item
	private _dirObj = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
	private _dirContent = _dirObj select 0;
	private _itemObj = _dirContent get _currentFile;

	if (isNil "_itemObj") throw "File not found";

	// Get new owner from UI
	private _newOwner = ctrlText (_display displayCtrl 1402);

	// Get new permissions from checkboxes
	private _ownerRead = cbChecked (_display displayCtrl 1310);
	private _ownerWrite = cbChecked (_display displayCtrl 1311);
	private _ownerExecute = cbChecked (_display displayCtrl 1312);

	private _everyoneRead = cbChecked (_display displayCtrl 1313);
	private _everyoneWrite = cbChecked (_display displayCtrl 1314);
	private _everyoneExecute = cbChecked (_display displayCtrl 1315);

	private _newPermissions = [
		[_ownerExecute, _ownerRead, _ownerWrite],
		[_everyoneExecute, _everyoneRead, _everyoneWrite]
	];

	// Update the item
	_itemObj set [1, _newOwner];
	_itemObj set [2, _newPermissions];

	// Save filesystem
	_entity setVariable ["AE3_filesystem", _filesystem, true];

	[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;

	hint localize "STR_AE3_Main_Zeus_ChangesApplied";
}
catch
{
	hint format [localize "STR_AE3_Main_Zeus_ChangesApplyFailed", _exception];
};
