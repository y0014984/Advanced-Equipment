/**
 * Refreshes the directory listing in the Move dialog.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Results:
 * None
 */

params ["_display"];

private _listbox = _display displayCtrl 1500;
private _pathCtrl = _display displayCtrl 1002;

private _pointer = _display getVariable ["AE3_move_pointer", []];
private _filesystem = _display getVariable ["AE3_filesystem", createHashMap];

// Update path display
private _pathString = "/" + (_pointer joinString "/");
_pathCtrl ctrlSetText _pathString;

// Clear listbox
lbClear _listbox;

// Get current directory content
private _dirObj = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;
private _dirContent = _dirObj select 0;

// Add only directories to the listbox
{
	private _name = _x;
	private _obj = _y;
	private _content = _obj select 0;

	// Only show directories
	if (typeName _content == "HASHMAP") then
	{
		private _index = _listbox lbAdd format ["[DIR]  %1", _name];
		_listbox lbSetData [_index, _name];
	};
} forEach _dirContent;

// Sort the listbox
lbSort _listbox;
