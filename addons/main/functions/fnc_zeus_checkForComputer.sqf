/**
 * PRIVATE
 *
 * This function is a helper function for the zeus module functions. It checks, after a module is placed,
 * if the module is placed an an entity that is an object and has a filesystem and is not currently used by
 * a player a a computer. In case of an error, zeus messages will appear, telling about the error.
 *
 * Arguments:
 * None
 *
 * Results:
 * 1: Status <STRING>
 * 2: Computer <OBJECT>
 *
 */

private _mouseOver = missionNamespace getVariable ["BIS_fnc_curatorObjectPlaced_mouseOver", [""]];
_mouseOver params ["_mouseOverType", "_mouseOverUnit"];

// check if module was placed on top of another object
if (_mouseOverType != "OBJECT") exitWith
{
    [objNull, localize "STR_AE3_Main_Zeus_NoComputer"] call BIS_fnc_showCuratorFeedbackMessage;

    ["ERROR", objNull];
};

// check if filesystem exists, which means that _mouseOverUnit is a computer
// ??? Is this also true for a USB Stick?
// TODO: Add a simple identifier to distinguish between device classes
private _computer = _mouseOverUnit;

// get filesystem var from server
[_computer, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;

private _filesystem = _computer getVariable ["AE3_filesystem", []];
if (_filesystem isEqualTo []) exitWith
{
    [objNull, localize "STR_AE3_Main_Zeus_NoComputer"] call BIS_fnc_showCuratorFeedbackMessage;

    ["ERROR", objNull];
};

// check if computer is currently used by checking the mutex variable
if (!isNull (_computer getVariable ['AE3_computer_mutex', objNull])) exitWith
{
    [objNull, localize "STR_AE3_Main_Zeus_ComputerInUse"] call BIS_fnc_showCuratorFeedbackMessage;

    ["ERROR", objNull];
};

["SUCCESS", _computer];