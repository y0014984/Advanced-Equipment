/**
 * Tries to find the given username in the list of local users. If found switches mode to password.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Username <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_username"];

private _terminal = _computer getVariable "AE3_terminal";

private _users = _computer getVariable ["AE3_Userlist", createHashMap];

private _result = [];
private _logMessage = "";

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
