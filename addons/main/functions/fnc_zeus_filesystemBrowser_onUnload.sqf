// File: fnc_zeus_filesystemBrowser_onUnload.sqf
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

// In pick mode, the bottom OK (exit code 1) must return the chosen path just like the "Select Path"
// button (fnc_zeus_filesystemBrowser_pickPath) - otherwise OK closed the browser and discarded it.
private _pickMode = uiNamespace getVariable ["AE3_zeus_fsBrowser_pickMode", false];
if (_pickMode && _exitCode == 1) then
{
    private _pointer = _display getVariable ["AE3_pointer", []];
    private _current = _display getVariable ["AE3_currentFile", ""];
    private _parts = +_pointer;
    if (_current isNotEqualTo "") then { _parts pushBack _current; };
    private _path = "/" + (_parts joinString "/");

    private _target = uiNamespace getVariable ["AE3_zeus_fsBrowser_pickTarget", []];
    if (count _target isEqualTo 2) then
    {
        _target params ["_targetDisplay", "_targetIdc"];
        if (!isNull _targetDisplay) then
        {
            (_targetDisplay displayCtrl _targetIdc) ctrlSetText _path;
        };
    };
};

if (_pickMode) then
{
    uiNamespace setVariable ["AE3_zeus_fsBrowser_pickMode", false];
    uiNamespace setVariable ["AE3_zeus_fsBrowser_pickTarget", nil];
};

// Clean up stored variables
missionNamespace setVariable ["AE3_zeus_filesystemBrowser_entity", nil];
