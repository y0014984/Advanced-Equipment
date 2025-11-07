/**
 * Creates a new file in the current directory.
 *
 * Arguments:
 * None
 *
 * Results:
 * None
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
