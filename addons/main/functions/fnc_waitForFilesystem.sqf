/*
 * Author: Root
 * Description: Waits for a computer's filesystem to be ready before proceeding. Used by Zeus modules to ensure filesystem is initialized before operations.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer object to check
 * 1: _timeoutSeconds <NUMBER> (Optional) - Timeout duration in seconds, default: 10
 *
 * Return Value:
 * Success <BOOL> - true if filesystem is ready, false if timeout occurred
 *
 * Example:
 * private _ready = [_computer] call AE3_main_fnc_waitForFilesystem;
 * private _ready = [_computer, 15] call AE3_main_fnc_waitForFilesystem;
 *
 * Public: Yes
 */

params ["_computer", ["_timeoutSeconds", 10]];

// Check if filesystem is ready
private _startTime = time;
private _timeout = _startTime + _timeoutSeconds;
private _filesystemReady = false;

waitUntil {
	_filesystemReady = _computer getVariable ["AE3_filesystemReady", false];
	_filesystemReady || time > _timeout
};

// Return success status
_filesystemReady
