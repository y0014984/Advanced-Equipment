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
		_result = ["   root login disabled"];
	}
	else
	{
		_result = [format ["   User: %1 not found", _username]];
	};

	_terminal deleteAt "AE3_terminalLoginUser";
};

[_computer, _result] call AE3_armaos_fnc_terminal_addLines;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
