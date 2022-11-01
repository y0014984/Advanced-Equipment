/**
 * Writes given log message to given logfile.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Sender <STRING>
 * 3: Log message <STRING>
 * 4: Path to Log file <STRING> (Optional)
 *
 * Results:
 * None
 *
 * Example:
 * --------
 * private _computer = cursorObject getVariable "AE3_Computer";
 * private _sender = "System";
 * private _logMessage = "Login by user 'admin' successful.";
 * private _logFile = "/var/log/auth.log";
 * [_computer, _sender, _logMessage, _logFile] call AE3_armaos_fnc_writeToLogfile;
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
        (if (_curDate select 1 < 10) then { "0" } else { "" }) + str (_curDate select 1),
        (if (_curDate select 2 < 10) then { "0" } else { "" }) + str (_curDate select 2)
    ];

private _dayTimeString = [dayTime, "HH:MM:SS"] call BIS_fnc_timeToString;

private _logMessage = format ["%1 %2 (%3): %4", _dateString, _dayTimeString, _sender, _logMessage];
_logMessage = _logMessage + endl;


[_pointer, _filesystem, _logFile, _user, _logMessage] call AE3_filesystem_fnc_appendToFile;



