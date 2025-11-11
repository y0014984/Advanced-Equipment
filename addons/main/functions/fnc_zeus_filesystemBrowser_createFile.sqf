/*
 * Author: Root
 * Description: Opens the New File dialog in the Zeus filesystem browser. Validates that the current directory is not a protected
 * system directory (/bin, /sbin, /etc) before opening the dialog. This is a button handler function.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_main_fnc_zeus_filesystemBrowser_createFile;
 *
 * Public: No
 */

private _display = findDisplay 16993;
if (isNull _display) exitWith {};

private _pointer = _display getVariable ["AE3_pointer", []];

// Check if trying to modify system folder
private _pathString = "/" + (_pointer joinString "/");
if (_pathString in ["/bin", "/sbin", "/etc"]) exitWith
{
	hint localize "STR_AE3_Main_Zeus_CannotModifySystemFolder";
};

// Open the new file dialog
createDialog "AE3_UserInterface_Zeus_Browser_NewFile";
