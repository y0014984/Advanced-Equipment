/*
 * Author: Root
 * Description: Writes a log entry to the terminal's log file for debugging and audit purposes.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _sender <STRING> - TODO: Add description
 * 2: _logMessage <STRING> - TODO: Add description
 * 3: _logFile <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _sender, _logMessage] call AE3_armaos_fnc_shell_writeToLogfile;
 *
 * Public: No
 */

params ["_computer", "_sender", "_logMessage", ["_logFile", "/var/log/syslog"]];

// YYYY-MM-DD HH:MM:SS (SENDER): MESSAGE

private _pointer = _computer getVariable "AE3_Filepointer";
private _filesystem = _computer getVariable "AE3_Filesystem";
private _user = "root"; 

date params ["_year", "_month", "_day", "_hours", "_minutes"];

private _curDate = date;
private _dateString = format
    [
        "%1-%2-%3",
        _curDate select 0,
        (["", "0"] select ((_curDate select 1) < 10)) + str (_curDate select 1),
        (["", "0"] select ((_curDate select 2) < 10)) + str (_curDate select 2)
    ];

private _dayTimeString = [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString;

private _logMessage = format ["%1 %2 (%3): %4", _dateString, _dayTimeString, _sender, _logMessage];
_logMessage = _logMessage + endl;


[_pointer, _filesystem, _logFile, _user, _logMessage, true] call AE3_filesystem_fnc_writeToFile;



