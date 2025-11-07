/**
 * Handles unloading of the filesystem browser display.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Exit Code <NUMBER>
 *
 * Results:
 * None
 */

params ["_display", "_exitCode"];

// Clean up stored variables
missionNamespace setVariable ["AE3_zeus_filesystemBrowser_entity", nil];
