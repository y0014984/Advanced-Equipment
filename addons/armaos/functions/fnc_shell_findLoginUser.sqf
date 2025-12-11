/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Finds and validates a login user in the computer's user list by checking username and password.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _username <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _username] call AE3_armaos_fnc_shell_findLoginUser;
 *
 * Public: No
 */

params ["_computer", "_username"];

private _terminal = _computer getVariable "AE3_terminal";

private _users = _computer getVariable ["AE3_Userlist", createHashMap];

private _result = [];
private _logMessage = "";

if (AE3_DebugMode) then
{
	private _debugUsername = [_username] call BIS_fnc_filterString; // (default filter a..z, A..Z, 0..9, "_")
	// no empty string allowed or changing an existing username
	if (((count _debugUsername) > 0) && !(_username in _users)) then { _username = _debugUsername; };
};

if ((_username in _users) || AE3_DebugMode) then
{
	_terminal set ["AE3_terminalLoginUser", _username];
	_terminal set ["AE3_terminalApplication", "PASSWORD"];
	_terminal set ["AE3_terminalPrompt", "PASSWORD>"];
}
else 
{
	if (_username isEqualTo "root") then
	{
		_logMessage = localize "STR_AE3_ArmaOS_Exception_RootLoginDisabled";
		[_computer, "System", _logMessage, "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;
	}
	else
	{
		_logMessage = format [localize "STR_AE3_ArmaOS_Exception_UserNotFound", _username];
		[_computer, "System", _logMessage, "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;
	};

	_result = ["   " + _logMessage];

	_terminal deleteAt "AE3_terminalLoginUser";
};

[_computer, _result] call AE3_armaos_fnc_terminal_addLines;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
