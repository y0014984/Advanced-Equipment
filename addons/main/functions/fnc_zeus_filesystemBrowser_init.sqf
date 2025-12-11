/*
 * Author: Root
 * Description: Initializes the Zeus filesystem browser display. Retrieves the entity from mission namespace, loads its filesystem,
 * and sets up the initial display state at the root directory. Closes the dialog if no valid entity is found.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The filesystem browser display
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call AE3_main_fnc_zeus_filesystemBrowser_init;
 *
 * Public: No
 */

params ["_display"];

private _entity = missionNamespace getVariable ["AE3_zeus_filesystemBrowser_entity", objNull];
if (isNull _entity) exitWith { closeDialog 0; };

private _filesystem = _entity getVariable ["AE3_filesystem", createHashMap];
private _pointer = [];

// Store state in display
_display setVariable ["AE3_entity", _entity];
_display setVariable ["AE3_pointer", _pointer];

// Update the file list
[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;
