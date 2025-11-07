/**
 * Handles double-clicking on a directory in the Move dialog to navigate into it.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Selected Index <NUMBER>
 *
 * Results:
 * None
 */

params ["_display", "_selectedIndex"];

private _listbox = _display displayCtrl 1500;
private _dirName = _listbox lbData _selectedIndex;

if (_dirName isEqualTo "") exitWith {};

// Get current pointer and add the selected directory
private _pointer = _display getVariable ["AE3_move_pointer", []];
_pointer pushBack _dirName;
_display setVariable ["AE3_move_pointer", _pointer];

// Refresh the listing
[_display] call AE3_main_fnc_zeus_filesystemBrowser_moveRefresh;
