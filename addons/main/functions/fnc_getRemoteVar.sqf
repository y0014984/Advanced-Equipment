/*
 * Author: Root
 * Description: Retrieves a variable from a remote client and sets it locally. Waits until the variable transfer is complete.
 *
 * Arguments:
 * 0: _namespace <NAMESPACE> - Namespace where the variable should be stored locally
 * 1: _variable <STRING> - Name of the variable to retrieve
 * 2: _from <NUMBER> (Optional) - Client ID to retrieve from, default: 2 (server)
 *
 * Return Value:
 * None
 *
 * Example:
 * [missionNamespace, "remoteData"] call AE3_main_fnc_getRemoteVar;
 * [missionNamespace, "remoteData", 3] call AE3_main_fnc_getRemoteVar; // From specific client
 *
 * Public: No
 */

params['_namespace', '_variable', ['_from', 2]];

if(!isMultiplayer) exitWith {};

private _transfer = _variable + "_trans";
_namespace setVariable [_transfer, false];

[clientOwner, _namespace, _variable] remoteExecCall ["AE3_main_fnc_sendVarToRemote", _from];

// Wait until the variable is set
waitUntil
{
	// if the var does not exist, waitUntil gets a nil error, because it expects true or false; therefore default value false
	// this could be the case if there are a lot of requests for a var
	_namespace getVariable [_transfer, false];
};
_namespace setVariable [_transfer, nil];
