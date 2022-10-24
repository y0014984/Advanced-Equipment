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

_namespace setVariable [_variable, nil];

[clientOwner, _namespace, _variable] remoteExecCall ["AE3_main_fnc_sendVarToRemote", _from];

// Wait until the variable is set
waitUntil
{
	!isNil {_namespace getVariable _variable};
}