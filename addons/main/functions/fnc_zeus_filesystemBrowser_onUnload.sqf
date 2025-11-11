/*
 * Author: Root
 * Description: Handles cleanup when the Zeus filesystem browser display is closed. Clears the stored entity reference from
 * mission namespace to prevent memory leaks.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The filesystem browser display being unloaded
 * 1: _exitCode <NUMBER> - Exit code from the display
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 1] call AE3_main_fnc_zeus_filesystemBrowser_onUnload;
 *
 * Public: No
 */

params ["_display", "_exitCode"];

// Clean up stored variables
missionNamespace setVariable ["AE3_zeus_filesystemBrowser_entity", nil];
