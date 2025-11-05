/**
 * Waits for a computer's filesystem to be ready before proceeding.
 * Used by Zeus modules to ensure filesystem is initialized before operations.
 *
 * Arguments:
 * 0: Computer <OBJECT>
 * 1: Timeout in seconds <NUMBER> (Optional, default: 10)
 *
 * Results:
 * Success <BOOL> - true if filesystem is ready, false if timeout occurred
 *
 * Example:
 * [_computer] call AE3_main_fnc_waitForFilesystem;
 * [_computer, 15] call AE3_main_fnc_waitForFilesystem;
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
