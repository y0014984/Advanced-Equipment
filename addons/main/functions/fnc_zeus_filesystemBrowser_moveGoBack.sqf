/**
 * Handles the "Go Back" button in the Move dialog to navigate up one directory.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 *
 * Results:
 * None
 */

params ["_display"];

private _pointer = _display getVariable ["AE3_move_pointer", []];

// If already at root, do nothing
if (count _pointer == 0) exitWith {};

// Remove last directory from pointer
_pointer deleteAt (count _pointer - 1);
_display setVariable ["AE3_move_pointer", _pointer];

// Refresh the listing
[_display] call AE3_main_fnc_zeus_filesystemBrowser_moveRefresh;
