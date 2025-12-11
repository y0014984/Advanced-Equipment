/*
 * Author: Root
 * Description: Returns the home directory path for a given username. Root user gets /root, other users get /home/<username>.
 *
 * Arguments:
 * 0: _username <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_username] call AE3_armaos_fnc_shell_getHomeDir;
 *
 * Public: No
 */


params['_username'];

if (_username isEqualTo "root") exitWith
{
	["root"];
};

["home", _username];
