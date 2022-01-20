/**
 * Tries to validate given username and password. If successful switches to shell mode.
 * If not successful switches back to login mode.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

params ["_computer"];

private _terminal = _computer getVariable "AE3_terminal";

private _username = _terminal get "AE3_terminalLoginUser";
private _password = _terminal get "AE3_terminalPasswordBuffer";

private _users = _computer getVariable [ "AE3_Userlist", [["topsykrett", "test123"]] ];

private _userIndex = _users find [_username, _password];

private _result = [];

if (_userIndex == -1) then 
{
	_result = [format ["   User: %1 failed login attempt", _username]];
	_terminal deleteAt "AE3_terminalLoginUser";
	_terminal deleteAt "AE3_terminalPasswordBuffer";
	_terminal set ["AE3_terminalApplication", "LOGIN"];
	_terminal set ["AE3_terminalPrompt", "LOGIN>"];
}
else 
{
	_terminal set ["AE3_terminalApplication", "SHELL"];
	[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
};

_result = _result + [""];
[_computer, _result] call AE3_armaos_fnc_terminal_addLines;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;