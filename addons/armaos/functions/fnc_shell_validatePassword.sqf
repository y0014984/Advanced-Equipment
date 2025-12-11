/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Validates a password against the stored password for a given username.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _password <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _password] call AE3_armaos_fnc_shell_validatePassword;
 *
 * Public: No
 */

params ["_computer", "_password"];

private _terminal = _computer getVariable "AE3_terminal";

private _username = _terminal get "AE3_terminalLoginUser";

private _users = _computer getVariable "AE3_Userlist";

private _result = [];
private _logMessage = "";

private _userPasswordMatch = false;

if (AE3_DebugMode) then
{
	_userPasswordMatch = true;
}
else
{
	_userPasswordMatch = ((_users get _username) isEqualTo _password);
};

if (_userPasswordMatch) then
{
	_logMessage = format [localize "STR_AE3_ArmaOS_Exception_UserLoginSuccessful", _username];
	[_computer, "System", _logMessage, "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;

	_terminal set ["AE3_terminalApplication", "SHELL"];

	private _terminalCommandHistory = _terminal get "AE3_terminalCommandHistory";
	_terminalCommandHistory getOrDefault [_username, [], true]; // set the user related history, if not existing yet

	if (AE3_DebugMode) then
	{
		_computer setVariable ["AE3_filepointer", []];
	}
	else
	{
		_computer setVariable ["AE3_filepointer", [_username] call AE3_armaos_fnc_shell_getHomeDir];
	};
	
	[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
}
else
{
	_logMessage = format [localize "STR_AE3_ArmaOS_Exception_UserFailedLogin", _username];
	[_computer, "System", _logMessage, "/var/log/auth.log"] call AE3_armaos_fnc_shell_writeToLogfile;

	_terminal deleteAt "AE3_terminalLoginUser";
	_terminal set ["AE3_terminalApplication", "LOGIN"];
	_terminal set ["AE3_terminalPrompt", "LOGIN>"];
};

_result = ["   " + _logMessage];

[_computer, _result] call AE3_armaos_fnc_terminal_addLines;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
