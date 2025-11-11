/*
 * Author: Root
 * Description: Helper function for Zeus modules that validates the target object.
 * Checks if the module was placed on an object with a filesystem and that the computer is not currently in use (via ace_mutex check).
 * Provides Zeus feedback messages on error.
 *
 * Arguments:
 * None (uses BIS_fnc_curatorObjectPlaced_mouseOver from mission namespace)
 *
 * Return Value:
 * Array with status and computer object <ARRAY>:
 * 0: _status <STRING> - "SUCCESS" or "ERROR"
 * 1: _computer <OBJECT> - The computer object, or objNull on error
 *
 * Example:
 * private _result = [] call AE3_main_fnc_zeus_checkForComputer;
 * _result params ["_status", "_computer"];
 *
 * Public: No
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
