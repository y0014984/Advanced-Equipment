/**
 * Gets a remote variable and sets it locally.
 *
 * Arguments:
 * 0: Namespace of the variable <NAMESPACE>
 * 1: Variable name <STRING>
 * 2: Remote client (OPTIONAL)
 * 
 * Return:
 * Nothing
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