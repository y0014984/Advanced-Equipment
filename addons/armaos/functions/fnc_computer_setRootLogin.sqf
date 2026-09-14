// File: fnc_computer_setRootLogin.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Sets a computer's own root login policy and root password, overriding the mission-wide
 * AE3_AllowRootLogin setting for that computer only. The policy is stored in AE3_allowRootLogin, the
 * password in AE3_rootPassword; both are broadcast, and the password is also written into the
 * computer's user list so the login prompt accepts it. Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to configure
 * 1: _allowed <ANY> (Optional, default: "default") - true/"allow" to allow, false/"deny" to deny,
 *    "default"/"" to clear the override and follow the mission-wide setting again
 * 2: _password <STRING> (Optional, default: "") - New root password; "" keeps the current one
 *
 * Return Value:
 * true if the policy was applied <BOOL>
 *
 * Example:
 * [_laptop, true, "hunter2"] call AE3_armaos_fnc_computer_setRootLogin;
 *
 * Public: Yes
 */

params [["_computer", objNull, [objNull]], ["_allowed", "default"], ["_password", "", [""]]];

if (!isServer) exitWith { false };
if (isNull _computer) exitWith { false };

private _policy = "";

if (_allowed isEqualType true) then
{
	_policy = ["deny", "allow"] select _allowed;
}
else
{
	if (_allowed isEqualType "") then
	{
		private _value = toLower _allowed;
		if (_value in ["allow", "deny"]) then { _policy = _value; };
	};
};

_computer setVariable ["AE3_allowRootLogin", _policy, true];

if (_password isNotEqualTo "") then
{
	[_computer, _password] call AE3_armaos_fnc_computer_setRootPassword;
};

true
