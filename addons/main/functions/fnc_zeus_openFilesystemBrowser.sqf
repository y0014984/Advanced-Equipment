/**
 * Opens the filesystem browser for the selected Zeus entity.
 *
 * Arguments:
 * None
 *
 * Results:
 * None
 */

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

// Check if entity has a filesystem
if (isNil {_entity getVariable "AE3_filesystem"}) exitWith
{
	[objNull, localize "STR_AE3_Main_Zeus_NoFilesystem"] call BIS_fnc_showCuratorFeedbackMessage;
};

// Store entity reference for the browser
missionNamespace setVariable ["AE3_zeus_filesystemBrowser_entity", _entity];

// Open the browser dialog
createDialog "AE3_UserInterface_Zeus_FilesystemBrowser";
