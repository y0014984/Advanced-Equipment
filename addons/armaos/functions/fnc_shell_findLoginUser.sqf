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

private _users = _computer getVariable "AE3_Userlist";

private _result = [];

private _userIndex = -1;
{
	scopeName "user";
	if (_username isEqualTo (_x select 0)) then
	{
		_userIndex = _forEachIndex;
		breakOut "user";
	};
} forEach _users;

if (_userIndex == -1) then 
{
	_result = [format ["   User: %1 not found", _username]];
	_terminal deleteAt "AE3_terminalLoginUser";
}
else 
{
	_terminal set ["AE3_terminalLoginUser", _username];
	_terminal set ["AE3_terminalApplication", "PASSWORD"];
	_terminal set ["AE3_terminalPrompt", "PASSWORD>"];
};

_result = _result + [""];
[_computer, _result] call AE3_armaos_fnc_terminal_addLines;
[_computer] call AE3_armaos_fnc_terminal_setPrompt;
